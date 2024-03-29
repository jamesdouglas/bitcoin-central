module ActionMailerDefaults
  def mail_with_logo(args, &block)
    attachments.inline['logo-wide.png'] = File.read(File.join(Rails.root, "app", "assets", "images", "logo-wide.png"))
    mail_without_logo(args, &block)
  end

  def self.included(base)
    base.class_eval do
      default :from => "TradeBitcoin support <support@tradebitcoin.com>"
      layout 'mailers'
      alias_method_chain :mail, :logo
    end
  end
end

class BitcoinCentralMailer < ActionMailer::Base
  include ActionMailerDefaults
end
