task drug: :environment do
  workbook = RubyXL::Parser.parse(Rails.root.join('drug.xlsx'))
  sheet = workbook[0]
  # green 61631 61472
  # orange 61602 61472
  # yellow 61472
  # red 61592 61472
  # black 61686 61472
end