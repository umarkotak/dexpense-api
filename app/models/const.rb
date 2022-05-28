class Const < ActiveRecord::Base
  MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Okt', 'Nov', 'Dec'].freeze

  DAYS = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'].freeze

  TRANSACTION_CATEGORIES = [
    "food",
    "daily_needs",
    "social_life",
    "self_development",
    "transportation",
    "household",
    "apparel",
    "beauty",
    "health",
    "education",
    "gift",
    "infaq",
    "admin_fee",
    "debt",
    "investation",
    "fee",
    "toys",
    "entertainment",

    "allowance",
    "salary",
    "petty_cash",
    "bonus",

    "transfer",
    "adjustment",
    "other",
  ].freeze

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
end
