class Const < ActiveRecord::Base
  MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Okt', 'Nov', 'Dec'].freeze

  DAYS = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'].freeze

  TRANSACTION_CATEGORIES_MAP = {
    "food" => {"id" => "Makanan", "en" => "Food"},
    "daily_needs" => {"id" => "Kebutuhan Harian", "en" => "Daily Needs"},
    "social_life" => {"id" => "Sosial", "en" => "Social Life"},
    "self_development" => {"id" => "Pengembangan Diri", "en" => "Self Development"},
    "transportation" => {"id" => "Transportasi", "en" => "Transportation"},
    "household" => {"id" => "Kebutuhan Rumah", "en" => "Household"},
    "apparel" => {"id" => "Pakaian", "en" => "Apparel"},
    "beauty" => {"id" => "Kecantikan", "en" => "Beauty"},
    "health" => {"id" => "Kesehatan", "en" => "Health"},
    "education" => {"id" => "Pendidikan", "en" => "Education"},
    "gift" => {"id" => "Hadiah", "en" => "Gift"},
    "infaq" => {"id" => "Infaq", "en" => "Infaq"},
    "admin_fee" => {"id" => "Biaya Admin", "en" => "Admin Fee"},
    "debt" => {"id" => "Hutang", "en" => "Debt"},
    "investation" => {"id" => "Investasi", "en" => "Investation"},
    "fee" => {"id" => "Biaya Tambahan", "en" => "Fee"},
    "toys" => {"id" => "Mainan", "en" => "Toys"},
    "entertainment" => {"id" => "Hiburan", "en" => "Entertainment"},

    "allowance" => {"id" => "Uang Jajan", "en" => "Allowance"},
    "salary" => {"id" => "Gaji", "en" => "Salary"},
    "petty_cash" => {"id" => "Uang Kaget", "en" => "Petty Cash"},
    "bonus" => {"id" => "Bonus", "en" => "Bonus"},

    "transfer" => {"id" => "Transfer", "en" => "Transfer"},
    "adjustment" => {"id" => "Adjustment", "en" => "Adjustment"},
    "other" => {"id" => "Lainnya", "en" => "Other"},
  }

  WEALTH_ASSET_RULES_MAP = {
    "gold" => {
      "category": "gold",
      "id": "Emas",
      "en": "Gold",
      "fa_icon": "",
      "index": 1,
      "sub_categories_map": {
        "antam_0.5g": {
          "weight": 0.5,
          "unit": "gram",
          "sub_category": "antam_0.5g",
          "id": "Antam 0.5g",
          "en": "Antam 0.5g",
          "index": 1,
        },
        "antam_1g": {
          "weight": 1,
          "unit": "gram",
          "sub_category": "antam_1g",
          "id": "Antam 1g",
          "en": "Antam 1g",
          "index": 2,
        },
        "antam_2g": {
          "weight": 2,
          "unit": "gram",
          "sub_category": "antam_2g",
          "id": "Antam 2g",
          "en": "Antam 2g",
          "index": 3,
        },
        "antam_3g": {
          "weight": 3,
          "unit": "gram",
          "sub_category": "antam_3g",
          "id": "Antam 3g",
          "en": "Antam 3g",
          "index": 4,
        },
        "antam_5g": {
          "weight": 5,
          "unit": "gram",
          "sub_category": "antam_5g",
          "id": "Antam 5g",
          "en": "Antam 5g",
          "index": 5,
        },
        "antam_10g": {
          "weight": 10,
          "unit": "gram",
          "sub_category": "antam_10g",
          "id": "Antam 10g",
          "en": "Antam 10g",
          "index": 6,
        },
        "antam_25g": {
          "weight": 25,
          "unit": "gram",
          "sub_category": "antam_25g",
          "id": "Antam 25g",
          "en": "Antam 25g",
          "index": 7,
        },
        "antam_50g": {
          "weight": 50,
          "unit": "gram",
          "sub_category": "antam_50g",
          "id": "Antam 50g",
          "en": "Antam 50g",
          "index": 8,
        },
        "antam_100g": {
          "weight": 100,
          "unit": "gram",
          "sub_category": "antam_100g",
          "id": "Antam 100g",
          "en": "Antam 100g",
          "index": 9,
        },
      }
    },
    "deposit" => {
      "category": "deposit",
      "id": "Deposito",
      "en": "Deposit",
      "fa_icon": "",
      "index": 2,
      "sub_categories_map": {
        "bank": {
          "sub_category": "bank",
          "id": "Bank",
          "en": "Bank",
          "index": 1,
        },
      }
    },
    "house" => {
      "category": "house",
      "id": "Rumah",
      "en": "House",
      "fa_icon": "",
      "index": 3,
      "sub_categories_map": {
        "house": {
          "sub_category": "house",
          "id": "House",
          "en": "House",
          "index": 1,
        },
      }
    },
  }

  def self.wealth_asset_to_arr
    init_val = WEALTH_ASSET_RULES_MAP
    new_val = init_val.keys.map do |key|
      init_val[key][:sub_categories_map] = init_val[key][:sub_categories_map].keys.map { |sub_key| init_val[key][:sub_categories_map][sub_key] }
      init_val[key]
    end
    new_val
  end
end
