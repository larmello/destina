class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')
    @user = params[:user] # Instance variable => available in view
    mail(to: @user.email, subject: 'Bem-vindo(a) ao portal de doações da RFB!')
    # This will render a view in `app/views/user_mailer`!
  end
end
