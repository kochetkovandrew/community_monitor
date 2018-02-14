task drug: :environment do
  #workbook = RubyXL::Parser.parse(Rails.root.join('drug.xlsx'))
  #sheet = workbook[0]
  # green 61631 61472
  # orange 61602 61472
  # yellow 61472
  # red 61592 61472
  # black 61686 61472
  drugs = {
    'ATV' => ['Atazanavir', 'Reyataz'],
    'Cobi' => ['Cobicistat', 'Tybost'],
    'DRV' => ['Darunavir', 'Prezista'],
    'FPV' => ['Fosamprenavir', 'Telzir', 'Lexiva'],
    'IDV' => ['Indinavir', 'Crixivan'],
    'LPV' => ['Lopinavir', 'Kaletra'],
    'RTV' => ['Ritonavir', 'Norvir'],
    'SQV' => ['Saquinavir', 'Invirase'],
    'TPV' => ['Tipranavir', 'Aptivus'],
  }
  art_abbreviations = ['ATV', 'Cobi', 'DRV', 'FPV', 'IDV', 'LPV', 'RTV', 'SQV', 'TPV']
  art_drugs = []
  drug_group = DrugGroup.where(name: 'Protease Inhibitors').first_or_create(
    translation: 'Ингибиторы протеазы'
  )
  art_abbreviations.each do |abbreviation|
    art_drug = ArtDrug.where(abbreviation: abbreviation).first_or_create(drug_group_id: drug_group.id)
    art_drugs.push art_drug
  end
  drug_group = DrugGroup.new
  CSV.foreach(Rails.root.join('druginteractions-pi.csv')) do |row|
    # use row here...
    if row[1].nil?
      drug_group = DrugGroup.where(name: row[0]).first_or_create
    else
      other_drug = OtherDrug.where(name: row[0]).first_or_create(
        name: row[0],
        drug_group_id: drug_group.id,
      )
      row[1].gsub!(' ', '')
      art_drugs.zip(row[1].split('')).each do |elem|
        art_drug_other_drug = ArtDrugOtherDrug.create(
          art_drug_id: elem[0].id,
          other_drug_id: other_drug.id,
          interaction: elem[1],
        )
      end
    end
  end
end