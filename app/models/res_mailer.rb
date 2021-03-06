class ResMailer < ActionMailer::Base
  include MyLib

  def reservation_confirmation(reservation, email, option)
    @from = email.sender
    @recipients = reservation.camper.email
    @subject = email.confirm_subject
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @headers = {}
    @sent_on = currentTime
    payment = Payment.total(reservation.id)
    if option.use_override and reservation.override_total > 0.0
      charges = reservation.override_total + reservation.tax_amount
    else
      charges = reservation.total + reservation.tax_amount
    end
    due = charges - payment
    @body = {"camper"     => reservation.camper.full_name,
             "start"      => DateFmt.format_date(reservation.startdate),
	     "departure"  => DateFmt.format_date(reservation.enddate),
	     "number"     => reservation.id.to_s,
	     "space_name" => reservation.space.name,
	     "charges"    => number_2_currency(charges),
	     "payment"    => number_2_currency(payment),
	     "deposit"    => number_2_currency(reservation.deposit),
	     "due"        => number_2_currency(due),
	     "reply"      => email.reply
	     }
  end
  
  def reservation_update(reservation, email, option)
    @from = email.sender
    @recipients = reservation.camper.email
    @subject = email.update_subject
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @headers = {}
    @sent_on = currentTime
    payment = Payment.total(reservation.id)
    if option.use_override and reservation.override_total > 0.0
      charges = reservation.override_total + reservation.tax_amount
    else
      charges = reservation.total + reservation.tax_amount
    end
    due = charges - payment
    @body = {"camper"     => reservation.camper.full_name,
             "start"      => DateFmt.format_date(reservation.startdate),
	     "departure"  => DateFmt.format_date(reservation.enddate),
	     "number"     => reservation.id.to_s,
	     "space_name" => reservation.space.name,
	     "charges"    => number_2_currency(charges),
	     "payment"    => number_2_currency(payment),
	     "deposit"    => number_2_currency(reservation.deposit),
	     "due"        => number_2_currency(due),
	     "reply"      => email.reply
	     }
  end
  
  def reservation_feedback(reservation, email, option)
    @from = email.sender
    @recipients = reservation.camper.email
    @subject = email.feedback_subject
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @headers = {}
    @sent_on = currentTime
    payment = Payment.total(reservation.id)
    if option.use_override and reservation.override_total > 0.0
      charges = reservation.override_total + reservation.tax_amount
    else
      charges = reservation.total + reservation.tax_amount
    end
    due = charges - payment
    @body = {"camper"     => reservation.camper.full_name,
             "start"      => DateFmt.format_date(reservation.startdate),
	     "departure"  => DateFmt.format_date(reservation.enddate),
	     "number"     => reservation.id.to_s,
	     "space_name" => reservation.space.name,
	     "charges"    => number_2_currency(charges),
	     "payment"    => number_2_currency(payment),
	     "deposit"    => number_2_currency(reservation.deposit),
	     "due"        => number_2_currency(due),
	     "reply"      => email.reply
	     }
  end
  
  def remote_reservation_received(reservation, email, option)
    @from = email.sender
    @recipients = reservation.camper.email
    @subject = email.confirm_subject
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @headers = {}
    @sent_on = currentTime
    payment = Payment.total(reservation.id)
    if option.use_override and reservation.override_total > 0.0
      charges = reservation.override_total + reservation.tax_amount
    else
      charges = reservation.total + reservation.tax_amount
    end
    due = charges - payment
    @body = {"camper"     => reservation.camper.full_name,
             "start"      => DateFmt.format_date(reservation.startdate),
	     "departure"  => DateFmt.format_date(reservation.enddate),
	     "number"     => reservation.id.to_s,
	     "space_name" => reservation.space.name,
	     "charges"    => number_2_currency(charges),
	     "payment"    => number_2_currency(payment),
	     "deposit"    => number_2_currency(reservation.deposit),
	     "due"        => number_2_currency(due),
	     "reply"      => email.reply
	     }
  end
  
  def remote_reservation_confirmation(reservation, email, option)
    @from = email.sender
    @recipients = reservation.camper.email
    @subject = email.confirm_subject
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @headers = {}
    @sent_on = currentTime
    payment = Payment.total(reservation.id)
    if option.use_override and reservation.override_total > 0.0
      charges = reservation.override_total + reservation.tax_amount
    else
      charges = reservation.total + reservation.tax_amount
    end
    due = charges - payment
    @body = {"camper"     => reservation.camper.full_name,
             "start"      => DateFmt.format_date(reservation.startdate),
	     "departure"  => DateFmt.format_date(reservation.enddate),
	     "number"     => reservation.id.to_s,
	     "space_name" => reservation.space.name,
	     "charges"    => number_2_currency(charges),
	     "payment"    => number_2_currency(payment),
	     "deposit"    => number_2_currency(reservation.deposit),
	     "due"        => number_2_currency(due),
	     "reply"      => email.reply
	     }
  end
  
  def remote_reservation_reject(reservation, email, option)
    @from = email.sender
    @recipients = reservation.camper.email
    @subject = email.confirm_subject
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @headers = {}
    @sent_on = currentTime
    payment = Payment.total(reservation.id)
    if option.use_override and reservation.override_total > 0.0
      charges = reservation.override_total + reservation.tax_amount
    else
      charges = reservation.total + reservation.tax_amount
    end
    due = charges - payment
    @body = {"camper"     => reservation.camper.full_name,
             "start"      => DateFmt.format_date(reservation.startdate),
	     "departure"  => DateFmt.format_date(reservation.enddate),
	     "number"     => reservation.id.to_s,
	     "space_name" => reservation.space.name,
	     "charges"    => number_2_currency(charges),
	     "payment"    => number_2_currency(payment),
	     "deposit"    => number_2_currency(reservation.deposit),
	     "due"        => number_2_currency(due),
	     "reply"      => email.reply
	     }
  end
  
  def tst(email)
    @from       = email.sender
    @recipients = email.reply
    @subject    = 'Mailer Test'
    @cc = email.cc unless email.cc.empty?
    @bcc = email.bcc unless email.bcc.empty?
    @reply_to = email.reply unless email.reply.empty?
    @sent_on    = currentTime
    @headers = {}
    @body       = {:email => email}
  end

  def render_message(method_name, body)
    mail_template = MailTemplate.find_by_name(method_name)
    template = Liquid::Template.parse(mail_template.body)
    template.render body
  end

end
