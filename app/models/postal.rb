class Postal
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>


  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  field :code

  field :zipcode
  field :zipcode_old

  field :prefecture
  field :city
  field :town
  field :area

  field :prefecture_kana
  field :city_kana
  field :town_kana
  field :area_kana

  index :zipcode, :background => true

  class << self
    def parse_kogaki row
      {
        :code => row[0],

        :zipcode => row[2],
        :zipcode_old => row[1],

        :prefecture => row[6].toutf8,
        :city => row[7].toutf8,
        :town => row[8].toutf8,

        :prefecture_kana => row[3].toutf8,
        :city_kana => row[4].toutf8,
        :town_kana => row[5].toutf8,

      }
    end

    def parse_jigyosyo row
      {
        :code => row[0],

        :zipcode => row[7],
        :zipcode_old => row[8],

        :prefecture => row[3].toutf8,
        :city => row[4].toutf8,
        :town => (row[5]+row[6]).toutf8,

        :prefecture_kana => '',
        :city_kana => '',
        :town_kana => '',
      }
    end
  end
end
