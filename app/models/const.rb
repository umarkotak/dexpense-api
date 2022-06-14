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
      "sub_categories_map": {
        "antam_0.5g": {
          "weight": 0.5,
          "unit": "gram",
          "sub_category": "antam_0.5g",
          "id": "Antam 0.5g",
          "en": "Antam 0.5g",
        },
        "antam_1g": {
          "weight": 1,
          "unit": "gram",
          "sub_category": "antam_1g",
          "id": "Antam 1g",
          "en": "Antam 1g",
        },
        "antam_2g": {
          "weight": 2,
          "unit": "gram",
          "sub_category": "antam_2g",
          "id": "Antam 2g",
          "en": "Antam 2g",
        },
        "antam_3g": {
          "weight": 3,
          "unit": "gram",
          "sub_category": "antam_3g",
          "id": "Antam 3g",
          "en": "Antam 3g",
        },
        "antam_10g": {
          "weight": 10,
          "unit": "gram",
          "sub_category": "antam_10g",
          "id": "Antam 10g",
          "en": "Antam 10g",
        },
        "antam_25g": {
          "weight": 25,
          "unit": "gram",
          "sub_category": "antam_25g",
          "id": "Antam 25g",
          "en": "Antam 25g",
        },
        "antam_50g": {
          "weight": 50,
          "unit": "gram",
          "sub_category": "antam_50g",
          "id": "Antam 50g",
          "en": "Antam 50g",
        },
        "antam_100g": {
          "weight": 100,
          "unit": "gram",
          "sub_category": "antam_100g",
          "id": "Antam 100g",
          "en": "Antam 100g",
        },
      }
    }
  }
end
