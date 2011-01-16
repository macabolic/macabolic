require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def test_thank_you_email
    registration = registrations(:billy_gmail)

    # Send the email, then test that it got queued
    email = UserMailer.thank_you_email(registration).deliver
    assert !ActionMailer::Base.deliveries.empty?
    
    # Test the body of the sent email contains what we expect it to
    assert_equal [registration.email_address], emali.to
    assert_equal "Thank you for your interest in Macabolic.com!", email.subject

end
