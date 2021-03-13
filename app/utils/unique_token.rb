require 'securerandom'

class UniqueToken
  RANDOM_BITS =  [8, 9, 5, 6, 2, 0, 7, 3, 4, 1]
  THIRTY_SIX = ('0'..'9').to_a + ('a'..'z').to_a
  SIXTY_TWO = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  HEADING_CHARS = ('a'..'z').to_a

  def self.sequence
    Verhoeff.checksum_of ActiveRecord::Base.
      connection.
      select_value("SELECT nextval('uuid_sequence_seq')").
      to_i.to_s
  end
  def self.password(max_length = 64)
    (0..max_length-1).map { (32 + rand(127-32)).chr }.join('')
  end
  def self.generate(times = 1)
    result = []
    times.times do
      result << SecureRandom.uuid.gsub(/-/, '').to_i(16).to_s(36).reverse
    end
    result.join('')
  end
  def self.generate62(length = 6)
    length = length.to_i
    calc_length = length - 1
    codes = (1..calc_length).map do
      SIXTY_TWO[SecureRandom.random_number(SIXTY_TWO.length)]
    end.join('')
    codes + check_digit_from(codes, SIXTY_TWO)
  end
  # generate 9 columns numeric data from number.(eg. '0000001' -> 'nnnnnnnnn')
  def self.order_number_from_id(id)
    rb = SecureRandom.random_number(9) + 1
    bits = RANDOM_BITS.rotate rb
    shv = sprintf("%07d", id).split(//).map_with_index { |ic, index|
      (bits[index] + ic.to_i) % 10
    }
    val = [rb, shv].flatten.join('')
    Verhoeff.checksum_of val
  end

  def self.barcode_token(length, options = {})
    heading_chars = options[:heading_chars] || HEADING_CHARS
    if options[:no_check_digit]
      heading_chars.sample + SecureRandom.hex.hex.to_s(36)[0,length-1]
    else
      c = heading_chars.sample + SecureRandom.hex.hex.to_s(36)[0,length-2]
      cd = check_digit_from(c)
      c + cd
    end
  end
  def self.check_digit_from(c, source = THIRTY_SIX)
    sum = calc_source(c, source)
    source[(source.length - sum % source.length) - 1]
  end
  def self.calc_source(c, source = THIRTY_SIX)
    d = c.split(//).map { |ch| source.index(ch) }
    d.reverse.each_slice(2).map do |x, y|
      [(x * 2).divmod(source.length), y]
    end.flatten.compact.inject(:+)
  end
end
