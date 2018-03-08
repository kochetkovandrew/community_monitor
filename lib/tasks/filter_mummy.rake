task filter_mummy: :environment do
  typical_names = [
    "Елена",
    "Наталья",
    "Ольга",
    "Татьяна",
    "Ирина",
    "Светлана",
    "Оксана",
    "Марина",
    "Анна",
    "Юлия",
    "Екатерина",
    "Виктория",
    "Людмила",
    "Мария",
    "Надежда",
    "Галина",
    "Евгения",
    "Наталия",
    "Инна",
    "Олеся",
    "Анастасия",
    "Лариса",
    "Любовь",
    "Наташа",
    "Алла",
    "Александра",
    "Алена",
    "Валентина",
    "Оля",
    "Яна",
    "Лена",
    "Вера",
    "Натали",
    "Нина",
    "Алёна",
    "Ксения",
    "Лилия",
    "Жанна",
    "Таня",
    "Алина",
    "Маргарита",
    "Карина",
    "Кристина",
    "Анжелика",
    "Дарья",
    "Юля",
    "Вероника",
    "Света",
    "Катерина",
    "Диана",
    "Elena",
    "Катя",
    "Ксюша",
    "Валерия",
    "Полина",
    "Тамара",
    "Аня",
    "Ангелина",
    "Лидия",
    "Алиса",
    "Вика",
    "Елизавета",
    "Ира",
    "Лана",
    "Дина",
    "Анжела",
    "Мила",
    "Маша",
    "Инга",
    "Антонина",
    "Irina",
    "Настя",
    "Anna",
    "Ната",
    "Olga",
    "Арина",
    "Анюта",
    "Marina",
    "Леся",
    "Альбина",
    "Ульяна",
    "Надя",
    "Софья",
    "Natalia",
    "Svetlana",
    "София",
    "Женя",
    "Oksana",
    "Алеся",
    "Иришка",
    "Василиса",
    "Люба",
    "Natali",
    "Люда",
    "Рита",
    "Леночка",
    "Лара",
    "Олька",
    "Даша",
    "Соня",
    "Саша",
    "Galina",
    "Танюша",
    "Милена",
    "Светик",
    "Лия",
    "Лиза",
    "Танюшка",
    "Оленька",
    "Варвара",
    "Tatiana",
    "Lena",
    "Лера",
    "Ekaterina",
    "Маришка",
    "Люся",
    "Inna",
    "Nata",
    "Олечка",
    "Маруся",
    "Александр",
    "Nina",
    "Yulia",
    "Танечка",
    "Галя",
    "Аленка",
    "Катюша",
    "Anastasia",
    "Валя",
    "Natalya",
    "Зина",
    "Tatyana",
    "Андрей",
    "Oxana",
    "Сергей",
    "Иринка",
    "Иван",
    "Юленька",
    "Ludmila",
    "Роман",
    "Лида",
    "Vera",
    "Julia",
    "Helen",
    "Alla",
    "Катенька",
    "Nataliya",
    "Κсения",
    "Дмитрий",
    "Надюша",
    "Максим",
    "Настасья",
    "Катюшка",
    "Alena",
    "Алексей",
    "Светланка",
    "Evgeniya",
    "Sofia",
    "Sveta",
    "Юлечка",
    "Maria",
    "Αлена",
    "Lyudmila",
    "Olya",
    "Ксюшка",
    "Olesya",
    "Виталий",
    "Diana",
    "Victoria",
    "Yuliya",
    "Натусик",
    "Мариша",
    "Kristina",
    "Alina",
    "Валентинка",
    "Макс",
    "Мариночка",
    "Ксюня",
    "Анечка",
    "Светочка",
    "Игорь",
    "Nadya",
    "Вася",
    "Маринка",
    "Polina",
    "Juliya",
    "Evgenia",
    "Татьянка",
    "Наташенька",
    "Μария",
    "Машенька",
    "Svetik",
    "Katerina",
    "Руслан",
    "Ирочка",
    "Vika",
    "Антон",
  ]
  people = JSON.parse File.read(Rails.root.join('applog', 'mummy3.json'))
  p people.count
  people.reject! {|person| person['first_name'].in?(typical_names)}
  #people.reject! {|person| person['followers_count'] < 500}
  p people.count
  names = {}
  people.each do |person|
    names[person['first_name']] ||= 0
    names[person['first_name']] += 1
  end
  names_array = names.map { |key, value| [key, value] }
  names_array.sort! {|x,y| y[1] <=> x[1]}
  # puts names_array.to_yaml
  f = File.open(Rails.root.join('filter_mummy2.yaml'), 'w')
  f.puts people.to_yaml
end
