module Kontena::Plugin::DigitalOcean::Prompts
  def ask_do_token
    if self.token.nil?
      prompt.ask('DigitalOcean API token: ', echo: false)
    else
      self.token
    end
  end

  def ask_droplet_region(do_token)
    if self.region.nil?
      prompt.select("Choose a datacenter region: ") do |menu|
        do_client = DropletKit::Client.new(access_token: do_token)
        do_client.regions.all.sort_by{|r| r.slug }.each{ |region|
          menu.choice region.name, region.slug
        }
      end
    else
      self.region
    end
  end

  def ask_droplet_size(do_token, do_region)
    if self.size.nil?
      prompt.select("Choose droplet size: ") do |menu|
        do_client = DropletKit::Client.new(access_token: do_token)
        do_client.sizes.all.to_a.select{ |s| s.memory > 1000 }.sort_by{|s| s.memory }.each{ |size|
          if size.regions.include?(do_region)
            menu.choice "#{size.slug} (#{size.price_monthly.to_i}USD/month)", size.slug
          end
        }
      end
    else
      self.size
    end
  end
end
