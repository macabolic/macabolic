class AddIndexToInvitations < ActiveRecord::Migration
  def change
    add_index :invitations, :token, { :name => "invitations_token_index" }
    add_index :invitations, [ :sender_id, :recipient_email ], { :name => "invitations_sender_id_recipient_email_index" }
  end
end
