class ExtraChargesController < ApplicationController
  before_filter :login_from_cookie
  before_filter :check_login
  
  def download_monthly
    extra_charges = []
    extra = Extra.find_by_extra_type Extra::MEASURED
    debug "extra id is #{extra.id} Date is #{Date.today}"
    ec = ExtraCharge.find_all_by_updated_on_and_extra_id  Date.today, extra.id
    debug "found #{ec.size} extra charges"
    ec.each_index do |i|
      if Reservation.find(ec[i].reservation_id).archived?
        debug "#{ec[i].reservation_id} is archived"
      else
        debug "#{ec[i].reservation_id} is not archived"
	extra_charges << ec[i]
      end
    end
    debug "kept #{extra_charges.size} extra charges"
    csv_string = "Space;Reservation;Name;Previous value;New value;Consumed;Rate;Charge\n"
    extra_charges.each do |e|
      csv_string << e.reservation.space.name + ';' + 
        e.reservation.id.to_s + ';' +
        e.reservation.camper.full_name + ';' +
        e.initial.to_s + ';' +
        e.final.to_s + ';' +
        (e.final - e.initial).to_s + ';' +
        e.measured_rate.to_s + ';' +
        e.charge.to_s + "\n"
    end
    send_data(csv_string,
              :type => 'text/csv;charset=iso-8859-1;header=present',
              :disposition => 'attachment; filename=Monthly.csv') if csv_string.length
  rescue => err
    debug 'no measured extras found: ' + err.to_s
    flash[:warning] = 'No measured extras found'
    redirect_to :action => :monthly_updates
  end

  def monthly_updates
    @page_title = I18n.t('titles.MeterReadings')
    ex = Extra.find_by_extra_type Extra::MEASURED
    unless ex
      flash[:warning] = 'No measured extras defined'
      redirect_to :action => :maintenance, :controller => :admin and return
    end
    debug 'found measured extra'
    @extra_charge = ExtraCharge.new :extra_id => ex.id
    debug 'created @extra_charge'
    ec = ExtraCharge.find_all_by_extra_id ex.id
    res = []
    ec.each { |e| res << e.reservation.id }
    if res.size > 0
      res.sort!.uniq!
      @reservations = Reservation.find res
      # Warning: following may have to be changed for rails 3+
      #          when @reservations will be a relation not an array
      @reservations.delete_if {|r| r.archived }
      debug "found #{@reservations.size} reservations"
    else
      flash[:notice] = "No reservations with #{ex.name}"
      redirect_to maintenance_index_path and return
    end
  rescue => err
    flash[:error] = err
    error err.to_s
    redirect_to maintenance_index_path and return
  end

  def update_monthly
    reservation = Reservation.find params[:reservation_id].to_i
    initial = reservation.space.current
    final = params[:extra_charge_final].to_f
    if final > initial
      ex = Extra.find_by_extra_type Extra::MEASURED
      consumed = final - initial
      charge = consumed * ex.rate
      extra_charge = ExtraCharge.create :extra_id => ex.id, :reservation_id => reservation.id, :initial => initial, :final => final, :charge => charge, :measured_rate => ex.rate
      reservation.space.update_attribute :current, final
      reservation.camper.active
    else
      final = initial
    end
    render :update do |page|
      if final == initial
	page[:flash].replace_html "space #{reservation.space.name} skipped"
	page[:flash][:style][:color] = 'yellow'
	page[:flash].visual_effect :highlight
      else
	page[('extra_consumed_' + reservation.id.to_s).to_sym].replace_html :text => consumed.to_s
	page[('extra_charge_' + reservation.id.to_s).to_sym].replace_html :text => number_2_currency(charge)
	page[:flash].replace_html "charges for reservation #{reservation.id} updated"
	page[:flash][:style][:color] = 'green'
	page[:flash].visual_effect :highlight
      end
    end
  end

  # GET /extra_charges
  def index
    @page_title = I18n.t('titles.MeasuredCharges')
    @extra_charges = []
    ec = ExtraCharge.all :include => ["extra","reservation"],
				     :conditions => ["extras.extra_type = ?", Extra::MEASURED], 
				     :order => "reservations.id, extra_charges.initial"
    debug "found #{ec.size} extra charges"
    ec.each_index do |i|
      if Reservation.find(ec[i].reservation_id).archived?
        debug "#{ec[i].reservation_id} is archived"
      else
        debug "#{ec[i].reservation_id} is not archived"
	@extra_charges << ec[i]
      end
    end
    debug "kept #{@extra_charges.size} extra charges"
    if @extra_charges.size == 0
      flash[:notice] = "No measured extra charges in the system"
      redirect_to maintenance_index_path and return
    end
  end

  # GET /extra_charges/1/edit
  def edit
    @extra_charge = ExtraCharge.find(params[:id].to_i)
    @page_title = I18n.t('titles.EditExtraCharge', :space => @extra_charge.reservation.space.name, :reservation_id => @extra_charge.reservation_id)
  end

  # PUT /extra_charges/1
  def update
    @extra_charge = ExtraCharge.find(params[:id].to_i)
    if @extra_charge.update_attributes(params[:extra_charge]) &&  @extra_charge.save_charges
      Reservation.find(@extra_charge.reservation_id).add_log("measured charge #{@extra_charge.id} updated")
      redirect_to(extra_charges_url, :notice => 'ExtraCharge was successfully updated.')
    else
      @page_title = I18n.t('titles.EditExtraCharge', :space => @extra_charge.reservation.space.name, :reservation_id => @extra_charge.reservation_id)
      flash[:error] = 'Update failed'
      render :action => "edit"
    end
  end

  # DELETE /extra_charges/1
  def destroy
    @extra_charge = ExtraCharge.find(params[:id].to_i)
    @extra_charge.destroy
    Reservation.find(@extra_charge.reservation_id).add_log("measured charge #{@extra_charge.id} deleted")
    redirect_to(extra_charges_url)
  end
end
