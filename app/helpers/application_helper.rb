module ApplicationHelper
  # Displays a menu option if the logged-in user matches the optional criteria
  def menu_item(label, link, options = {}, &block)
    if options.blank? or display_menu?(current_user, options)
      content_tag :li, :class => block ? 'dropdown' : '' do
        link_label = t(label)
        link_attributes = {"class" => "dropdown-toggle"}
        if block
          link_label += content_tag(:b, '', {:class => "caret"})
          link_attributes[:href] = '#'
          link_attributes["data-toggle"] = "dropdown"
        end
        out = link_to(raw(link_label), link, link_attributes)
        if block
          out += block_is_haml?(block) ? capture_haml(&block) : block.call
        end
        
        out
      end
    end
  end

  # account sidebar
  def render_menu_item(label, path)
    content_tag :li, :class => (path == request.path ? 'active' : '' ) do
      link_to t(label), path
    end
  end
  
  # Checks whether the option should be displayed to the currently logged-in user
  def display_menu?(user, options)
    options.blank? || (user && (user.is_a?(Admin) || (user.is_a?(Manager) && options[:manager]) || (user.merchant? && options[:merchant]) || (user && options[:logged_in])))
  end

  def number_to_bitcoins(amount, options = {})
    number_to_human(amount, options) + " BTC"
  end

  def amount_field_value(amount)
    if amount.blank? or amount.zero?
      nil
    else
      amount.abs
    end
  end

  def errors_for(model, options = {})
    render :partial => 'layouts/errors', :locals => {
      :model => model,
      :message => options[:message],
      :translated_message => options[:translated_message]
    }
  end

  def creation_link(resource, label)
    content_tag :div, :class => "creation-link" do
      link_to "#{image_tag("add.gif", :alt => label, :title => label)} #{label}".html_safe,
        send("new_#{resource}_path")
    end
  end
  
  def currency_icon_for(currency)
    image_tag "currencies/#{currency.downcase}_icon.png", 
      :alt => currency,
      :title => currency,
      :class => "currency-icon"
  end

  def bbe_link(type, id)
    link_to(truncate(id, :length => 15, :omission => ""), "http://blockexplorer.com/#{type}/#{id}", :target => "_blank", :title => id)
  end

  def locale_switch_link(locale, url)
    scheme, address = url.split(":\/\/")
    first_subdomain = address.match(/^[^\.]+/)[0]

    if I18n.available_locales.map(&:to_s).include? first_subdomain
      address.gsub!(/^[^\.]+/, "")
    else
      address = ".#{address}"
    end

    "#{scheme}://#{locale}#{address}"
  end
  
  def qrcode_image_tag(data)
    image_tag(qrcode_image_path(data), :class => "qrcode", :alt => data, :title => data)
  end
  
  def qrcode_image_path(data)
    qrcode_path(:data => CGI.escape(data))
  end

  def include_related_asset(asset)
        if !BitcoinBank::Application.assets.find_asset(asset).nil?
            case asset.split('.')[-1]
                when 'js'
                    javascript_include_tag asset
                when 'css'
                    stylesheet_link_tag asset
            end
        end
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def description(page_description)
    content_for :description, page_description.to_s
  end
  
  def keywords(page_keywords)
    content_for :keywords, page_keywords.to_s
  end

  def bank_account_details_column(record)
    if !record.bank_account.nil?

      data = "BIC: #{record.bank_account.bic}<br />IBAN: #{record.bank_account.iban}<br />Owner: #{record.bank_account.account_holder.html_safe}<br />Currency: #{record.bank_account.currency}<br />Type: #{record.bank_account.bank_type}"
      return data.html_safe
    else
      return '-'
    end
    
  end

end
