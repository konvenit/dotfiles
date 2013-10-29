require File.join(File.dirname(__FILE__), "common_helper")

module BoxHelper

  include CommonHelper

  def mappings
    %x{ssh deploy@strogatz.konvenit.com 'cat /etc/apache2/delivery_boxen.map'}.split(/\W+/)
  end

  def mapping
    @mapping ||= Hash[mappings.each_slice(2).to_a]
  end

  def ip(_box)
    box = _box.to_s.start_with?('mp') ? _box : "mp#{_box}"
    mapped_id = mapping[box]
    raise("no mapping for box:#{box}  \navailable boxes:\n#{mapping.keys.sort.join(',')}") unless mapped_id
    "10.0.3.#{mapping[box]}"
  end

  def login(box)
    box_ip = ip(box)
    puts "login to #{box} => #{box_ip}"
    system "ssh -A -t deploy@strogatz.konvenit.com ssh -A deploy@#{box_ip}"
  end

end
