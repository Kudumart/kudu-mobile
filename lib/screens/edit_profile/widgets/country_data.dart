final Map<String, List<String>> statesByCountry = {
  'Nigeria': [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara',
  ],
  'United States': [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ],
  'Canada': [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Nova Scotia',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
    'Northwest Territories',
    'Nunavut',
    'Yukon'
  ],
  'United Kingdom': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
  'Australia': [
    'New South Wales',
    'Victoria',
    'Queensland',
    'Western Australia',
    'South Australia',
    'Tasmania',
    'Australian Capital Territory',
    'Northern Territory'
  ],
  'India': [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ],
  'Germany': [
    'Baden-Württemberg',
    'Bavaria',
    'Berlin',
    'Brandenburg',
    'Bremen',
    'Hamburg',
    'Hesse',
    'Lower Saxony',
    'Mecklenburg-Vorpommern',
    'North Rhine-Westphalia',
    'Rhineland-Palatinate',
    'Saarland',
    'Saxony',
    'Saxony-Anhalt',
    'Schleswig-Holstein',
    'Thuringia'
  ],
  'France': [
    'Auvergne-Rhône-Alpes',
    'Bourgogne-Franche-Comté',
    'Brittany',
    'Centre-Val de Loire',
    'Corsica',
    'Grand Est',
    'Hauts-de-France',
    'Île-de-France',
    'Normandy',
    'Nouvelle-Aquitaine',
    'Occitanie',
    'Pays de la Loire',
    "Provence-Alpes-Côte d'Azur"
  ],
  'Japan': [
    'Hokkaido',
    'Aomori',
    'Iwate',
    'Miyagi',
    'Akita',
    'Yamagata',
    'Fukushima',
    'Ibaraki',
    'Tochigi',
    'Gunma',
    'Saitama',
    'Chiba',
    'Tokyo',
    'Kanagawa',
    'Niigata',
    'Toyama',
    'Ishikawa',
    'Fukui',
    'Yamanashi',
    'Nagano',
    'Gifu',
    'Shizuoka',
    'Aichi',
    'Mie',
    'Shiga',
    'Kyoto',
    'Osaka',
    'Hyogo',
    'Nara',
    'Wakayama',
    'Tottori',
    'Shimane',
    'Okayama',
    'Hiroshima',
    'Yamaguchi',
    'Tokushima',
    'Kagawa',
    'Ehime',
    'Kochi',
    'Fukuoka',
    'Saga',
    'Nagasaki',
    'Kumamoto',
    'Oita',
    'Miyazaki',
    'Kagoshima',
    'Okinawa'
  ],
  'China': [
    'Anhui',
    'Beijing',
    'Chongqing',
    'Fujian',
    'Gansu',
    'Guangdong',
    'Guangxi',
    'Guizhou',
    'Hainan',
    'Hebei',
    'Heilongjiang',
    'Henan',
    'Hubei',
    'Hunan',
    'Inner Mongolia',
    'Jiangsu',
    'Jiangxi',
    'Jilin',
    'Liaoning',
    'Ningxia',
    'Qinghai',
    'Shaanxi',
    'Shandong',
    'Shanghai',
    'Shanxi',
    'Sichuan',
    'Tianjin',
    'Tibet',
    'Xinjiang',
    'Yunnan',
    'Zhejiang'
  ],
  'Brazil': [
    'Acre',
    'Alagoas',
    'Amapá',
    'Amazonas',
    'Bahia',
    'Ceará',
    'Distrito Federal',
    'Espírito Santo',
    'Goiás',
    'Maranhão',
    'Mato Grosso',
    'Mato Grosso do Sul',
    'Minas Gerais',
    'Pará',
    'Paraíba',
    'Paraná',
    'Pernambuco',
    'Piauí',
    'Rio de Janeiro',
    'Rio Grande do Norte',
    'Rio Grande do Sul',
    'Rondônia',
    'Roraima',
    'Santa Catarina',
    'São Paulo',
    'Sergipe',
    'Tocantins'
  ],
  'Mexico': [
    'Aguascalientes',
    'Baja California',
    'Baja California Sur',
    'Campeche',
    'Chiapas',
    'Chihuahua',
    'Coahuila',
    'Colima',
    'Durango',
    'Guanajuato',
    'Guerrero',
    'Hidalgo',
    'Jalisco',
    'México',
    'Mexico City',
    'Michoacán',
    'Morelos',
    'Nayarit',
    'Nuevo León',
    'Oaxaca',
    'Puebla',
    'Querétaro',
    'Quintana Roo',
    'San Luis Potosí',
    'Sinaloa',
    'Sonora',
    'Tabasco',
    'Tamaulipas',
    'Tlaxcala',
    'Veracruz',
    'Yucatán',
    'Zacatecas'
  ],
  'Italy': [
    'Abruzzo',
    'Aosta Valley',
    'Apulia',
    'Basilicata',
    'Calabria',
    'Campania',
    'Emilia-Romagna',
    'Friuli Venezia Giulia',
    'Lazio',
    'Liguria',
    'Lombardy',
    'Marche',
    'Molise',
    'Piedmont',
    'Sardinia',
    'Sicily',
    'Tuscany',
    'Trentino-South Tyrol',
    'Umbria',
    'Veneto'
  ],
  'Spain': [
    'Andalusia',
    'Aragon',
    'Asturias',
    'Balearic Islands',
    'Basque Country',
    'Canary Islands',
    'Cantabria',
    'Castile and León',
    'Castilla-La Mancha',
    'Catalonia',
    'Extremadura',
    'Galicia',
    'La Rioja',
    'Madrid',
    'Murcia',
    'Navarre',
    'Valencia'
  ],
  'South Korea': [
    'Seoul',
    'Busan',
    'Daegu',
    'Incheon',
    'Gwangju',
    'Daejeon',
    'Ulsan',
    'Sejong',
    'Gyeonggi',
    'Gangwon',
    'North Chungcheong',
    'South Chungcheong',
    'North Jeolla',
    'South Jeolla',
    'North Gyeongsang',
    'South Gyeongsang',
    'Jeju'
  ],
  'Russia': [
    'Moscow',
    'Saint Petersburg',
    'Novosibirsk',
    'Yekaterinburg',
    'Kazan',
    'Nizhny Novgorod',
    'Chelyabinsk',
    'Krasnoyarsk',
    'Samara',
    'Ufa',
    'Rostov-on-Don',
    'Omsk',
    'Krasnodar',
    'Voronezh',
    'Volgograd',
    'Republic of Crimea',
    'Sevastopol'
  ],
  'South Africa': [
    'Eastern Cape',
    'Free State',
    'Gauteng',
    'KwaZulu-Natal',
    'Limpopo',
    'Mpumalanga',
    'North West',
    'Northern Cape',
    'Western Cape'
  ],
  'New Zealand': [
    'Auckland',
    'Bay of Plenty',
    'Canterbury',
    'Gisborne',
    'Hawke\'s Bay',
    'Marlborough',
    'Nelson',
    'Northland',
    'Otago',
    'Southland',
    'Taranaki',
    'Tasman',
    'Waikato',
    'Wellington',
    'West Coast'
  ],
  'Argentina': [
    'Buenos Aires',
    'Catamarca',
    'Chaco',
    'Chubut',
    'Córdoba',
    'Corrientes',
    'Entre Ríos',
    'Formosa',
    'Jujuy',
    'La Pampa',
    'La Rioja',
    'Mendoza',
    'Misiones',
    'Neuquén',
    'Río Negro',
    'Salta',
    'San Juan',
    'San Luis',
    'Santa Cruz',
    'Santa Fe',
    'Santiago del Estero',
    'Tierra del Fuego',
    'Tucumán'
  ],
  'Sweden': [
    'Stockholm',
    'Uppsala',
    'Södermanland',
    'Östergötland',
    'Jönköping',
    'Kronoberg',
    'Kalmar',
    'Gotland',
    'Blekinge',
    'Skåne',
    'Halland',
    'Västra Götaland',
    'Värmland',
    'Örebro',
    'Västmanland',
    'Dalarna',
    'Gävleborg',
    'Västernorrland',
    'Jämtland',
    'Västerbotten',
    'Norrbotten'
  ],
  'Netherlands': [
    'Drenthe',
    'Flevoland',
    'Friesland',
    'Gelderland',
    'Groningen',
    'Limburg',
    'North Brabant',
    'North Holland',
    'Overijssel',
    'South Holland',
    'Utrecht',
    'Zeeland'
  ],
  'Switzerland': [
    'Aargau',
    'Appenzell Ausserrhoden',
    'Appenzell Innerrhoden',
    'Basel-Stadt',
    'Basel-Landschaft',
    'Bern',
    'Fribourg',
    'Geneva',
    'Glarus',
    'Graubünden',
    'Jura',
    'Lucerne',
    'Neuchâtel',
    'Nidwalden',
    'Obwalden',
    'Schaffhausen',
    'Schwyz',
    'Solothurn',
    'St. Gallen',
    'Thurgau',
    'Ticino',
    'Uri',
    'Valais',
    'Vaud',
    'Zug',
    'Zürich'
  ]
  // Add more countries as needed
};

// Cities by state
final Map<String, Map<String, List<String>>> citiesByState = {
  // United States
  'California': {
    'cities': [
      'Los Angeles',
      'San Francisco',
      'San Diego',
      'San Jose',
      'Sacramento',
      'Oakland',
      'Long Beach',
      'Fresno',
      'San Bernardino',
      'Santa Ana'
    ]
  },
  'New York': {
    'cities': [
      'New York City',
      'Buffalo',
      'Rochester',
      'Syracuse',
      'Albany',
      'White Plains',
      'Yonkers',
      'Schenectady',
      'Utica',
      'Binghamton'
    ]
  },
  'Texas': {
    'cities': [
      'Houston',
      'Austin',
      'Dallas',
      'San Antonio',
      'Fort Worth',
      'El Paso',
      'Arlington',
      'Corpus Christi',
      'Plano',
      'Lubbock'
    ]
  },
  'Florida': {
    'cities': [
      'Miami',
      'Orlando',
      'Jacksonville',
      'Tampa',
      'St. Petersburg',
      'Tallahassee',
      'Fort Lauderdale',
      'West Palm Beach',
      'Gainesville',
      'Clearwater'
    ]
  },

  // Canada
  'Ontario': {
    'cities': [
      'Toronto',
      'Ottawa',
      'Mississauga',
      'Hamilton',
      'London',
      'Windsor',
      'Kingston',
      'Kitchener',
      'Waterloo',
      'Niagara Falls'
    ]
  },
  'British Columbia': {
    'cities': [
      'Vancouver',
      'Victoria',
      'Surrey',
      'Burnaby',
      'Richmond',
      'Kelowna',
      'Abbotsford',
      'Kamloops',
      'Nanaimo',
      'Prince George'
    ]
  },

  // United Kingdom
  'England': {
    'cities': [
      'London',
      'Manchester',
      'Birmingham',
      'Liverpool',
      'Leeds',
      'Newcastle',
      'Bristol',
      'Sheffield',
      'Nottingham',
      'Leicester'
    ]
  },
  'Scotland': {
    'cities': [
      'Edinburgh',
      'Glasgow',
      'Aberdeen',
      'Dundee',
      'Inverness',
      'Perth',
      'Stirling',
      'St Andrews',
      'Paisley',
      'Falkirk'
    ]
  },

  // Australia
  'New South Wales': {
    'cities': [
      'Sydney',
      'Newcastle',
      'Wollongong',
      'Wagga Wagga',
      'Coffs Harbour',
      'Port Macquarie',
      'Albury',
      'Tamworth',
      'Orange',
      'Dubbo'
    ]
  },
  'Victoria': {
    'cities': [
      'Melbourne',
      'Geelong',
      'Ballarat',
      'Bendigo',
      'Shepparton',
      'Mildura',
      'Warrnambool',
      'Wodonga',
      'Traralgon',
      'Wangaratta'
    ]
  },

  // India
  'Maharashtra': {
    'cities': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Nashik',
      'Aurangabad',
      'Solapur',
      'Kolhapur',
      'Thane',
      'Navi Mumbai',
      'Amravati'
    ]
  },
  'Karnataka': {
    'cities': [
      'Bangalore',
      'Mysore',
      'Hubli',
      'Mangalore',
      'Belgaum',
      'Gulbarga',
      'Dharwad',
      'Shimoga',
      'Davangere',
      'Bijapur'
    ]
  },

  // Germany
  'Bavaria': {
    'cities': [
      'Munich',
      'Nuremberg',
      'Augsburg',
      'Regensburg',
      'Würzburg',
      'Ingolstadt',
      'Fürth',
      'Erlangen',
      'Bayreuth',
      'Bamberg'
    ]
  },
  'Berlin': {
    'cities': [
      'Mitte',
      'Kreuzberg',
      'Charlottenburg',
      'Spandau',
      'Neukölln',
      'Pankow',
      'Reinickendorf',
      'Steglitz',
      'Tempelhof',
      'Wedding'
    ]
  },

  // France
  'Île-de-France': {
    'cities': [
      'Paris',
      'Versailles',
      'Saint-Denis',
      'Boulogne-Billancourt',
      'Argenteuil',
      'Montreuil',
      'Saint-Germain-en-Laye',
      'Créteil',
      'Nanterre',
      'Courbevoie'
    ]
  },
  'Provence-Alpes-Côte d\'Azur': {
    'cities': [
      'Marseille',
      'Nice',
      'Toulon',
      'Aix-en-Provence',
      'Avignon',
      'Cannes',
      'Antibes',
      'La Seyne-sur-Mer',
      'Hyères',
      'Arles'
    ]
  },

  'Tokyo': {
    'cities': [
      'Shinjuku',
      'Shibuya',
      'Chiyoda',
      'Minato',
      'Setagaya',
      'Ota',
      'Suginami',
      'Edogawa',
      'Nerima',
      'Adachi'
    ]
  },
  'Osaka': {
    'cities': [
      'Osaka City',
      'Sakai',
      'Higashiosaka',
      'Hirakata',
      'Toyonaka',
      'Ibaraki',
      'Suita',
      'Takatsuki',
      'Yao',
      'Kadoma'
    ]
  },

  // China
  'Shanghai': {
    'cities': [
      'Pudong',
      'Huangpu',
      'Xuhui',
      'Changning',
      'Jing\'an',
      'Putuo',
      'Hongkou',
      'Yangpu',
      'Minhang',
      'Baoshan'
    ]
  },
  'Beijing': {
    'cities': [
      'Dongcheng',
      'Xicheng',
      'Chaoyang',
      'Haidian',
      'Fengtai',
      'Shijingshan',
      'Mentougou',
      'Fangshan',
      'Tongzhou',
      'Shunyi'
    ]
  },

  // Brazil
  'São Paulo': {
    'cities': [
      'São Paulo',
      'Campinas',
      'Santos',
      'São José dos Campos',
      'Sorocaba',
      'Ribeirão Preto',
      'São José do Rio Preto',
      'Piracicaba',
      'Bauru',
      'Marília'
    ]
  },
  'Rio de Janeiro': {
    'cities': [
      'Rio de Janeiro',
      'Niterói',
      'São Gonçalo',
      'Duque de Caxias',
      'Nova Iguaçu',
      'Petrópolis',
      'Volta Redonda',
      'Macaé',
      'Angra dos Reis',
      'Campos dos Goytacazes'
    ]
  },

  // Mexico
  'Mexico City': {
    'cities': [
      'Cuauhtémoc',
      'Miguel Hidalgo',
      'Benito Juárez',
      'Coyoacán',
      'Tlalpan',
      'Álvaro Obregón',
      'Iztapalapa',
      'Gustavo A. Madero',
      'Azcapotzalco',
      'Xochimilco'
    ]
  },

  'Lombardy': {
    'cities': [
      'Milan',
      'Bergamo',
      'Brescia',
      'Como',
      'Cremona',
      'Lecco',
      'Lodi',
      'Mantua',
      'Monza',
      'Pavia'
    ]
  },
  'Lazio': {
    'cities': [
      'Rome',
      'Frosinone',
      'Latina',
      'Rieti',
      'Viterbo',
      'Civitavecchia',
      'Tivoli',
      'Velletri',
      'Anzio',
      'Guidonia'
    ]
  },
  'Tuscany': {
    'cities': [
      'Florence',
      'Pisa',
      'Siena',
      'Livorno',
      'Arezzo',
      'Lucca',
      'Grosseto',
      'Massa',
      'Carrara',
      'Prato'
    ]
  },

  // SPAIN
  'Madrid': {
    'cities': [
      'Madrid',
      'Móstoles',
      'Alcalá de Henares',
      'Fuenlabrada',
      'Leganés',
      'Getafe',
      'Alcorcón',
      'Parla',
      'Torrejón de Ardoz',
      'Alcobendas'
    ]
  },
  'Catalonia': {
    'cities': [
      'Barcelona',
      'Girona',
      'Lleida',
      'Tarragona',
      'Sabadell',
      'Terrassa',
      'Badalona',
      'Hospitalet de Llobregat',
      'Mataró',
      'Reus'
    ]
  },
  'Andalusia': {
    'cities': [
      'Seville',
      'Málaga',
      'Granada',
      'Córdoba',
      'Cádiz',
      'Almería',
      'Jaén',
      'Huelva',
      'Marbella',
      'Jerez de la Frontera'
    ]
  },

  // RUSSIA
  'Moscow': {
    'cities': [
      'Central Moscow',
      'Zelenograd',
      'Troitsk',
      'Shcherbinka',
      'Moskovsky',
      'Vnukovo',
      'Voskresenskoye',
      'Krasnogorsk',
      'Khimki',
      'Mytishchi'
    ]
  },
  'Saint Petersburg': {
    'cities': [
      'Central Saint Petersburg',
      'Pushkin',
      'Petergof',
      'Kronstadt',
      'Kolpino',
      'Sestroretsk',
      'Lomonosov',
      'Pavlovsk',
      'Krasnoe Selo',
      'Zelenogorsk'
    ]
  },
  'Novosibirsk Oblast': {
    'cities': [
      'Novosibirsk',
      'Berdsk',
      'Iskitim',
      'Kuybyshev',
      'Karasuk',
      'Tatarsk',
      'Ob',
      'Barabinsk',
      'Cherepanovo',
      'Toguchin'
    ]
  },

  'Kyoto': {
    'cities': [
      'Kyoto City',
      'Uji',
      'Kameoka',
      'Joyo',
      'Muko',
      'Nagaokakyo',
      'Yawata',
      'Kyotanabe',
      'Kizugawa',
      'Ayabe'
    ]
  },

  // SOUTH KOREA
  'Seoul': {
    'cities': [
      'Gangnam',
      'Seocho',
      'Songpa',
      'Mapo',
      'Yongsan',
      'Jongno',
      'Jung',
      'Dongdaemun',
      'Seodaemun',
      'Eunpyeong'
    ]
  },
  'Busan': {
    'cities': [
      'Haeundae',
      'Suyeong',
      'Nam',
      'Buk',
      'Jung',
      'Dong',
      'Yeonje',
      'Geumjeong',
      'Gangseo',
      'Sasang'
    ]
  },
  'Incheon': {
    'cities': [
      'Jung',
      'Dong',
      'Nam',
      'Yeonsu',
      'Namdong',
      'Bupyeong',
      'Gyeyang',
      'Seo',
      'Michuhol',
      'Ganghwa'
    ]
  },

  // CHINA

  'Guangdong': {
    'cities': [
      'Guangzhou',
      'Shenzhen',
      'Dongguan',
      'Foshan',
      'Zhongshan',
      'Zhuhai',
      'Huizhou',
      'Jiangmen',
      'Zhaoqing',
      'Shantou'
    ]
  },

  'Minas Gerais': {
    'cities': [
      'Belo Horizonte',
      'Uberlândia',
      'Contagem',
      'Juiz de Fora',
      'Betim',
      'Montes Claros',
      'Ribeirão das Neves',
      'Uberaba',
      'Governador Valadares',
      'Ipatinga'
    ]
  },

  'North Holland': {
    'cities': [
      'Amsterdam',
      'Haarlem',
      'Zaanstad',
      'Haarlemmermeer',
      'Alkmaar',
      'Purmerend',
      'Hoorn',
      'Den Helder',
      'Velsen',
      'Amstelveen'
    ]
  },
  'South Holland': {
    'cities': [
      'Rotterdam',
      'The Hague',
      'Leiden',
      'Dordrecht',
      'Zoetermeer',
      'Delft',
      'Schiedam',
      'Gouda',
      'Spijkenisse',
      'Vlaardingen'
    ]
  },
  'Utrecht': {
    'cities': [
      'Utrecht',
      'Amersfoort',
      'Zeist',
      'Nieuwegein',
      'Veenendaal',
      'Houten',
      'Woerden',
      'IJsselstein',
      'Soest',
      'De Bilt'
    ]
  },

  // SWEDEN
  'Stockholm': {
    'cities': [
      'Stockholm',
      'Södertälje',
      'Norrtälje',
      'Nacka',
      'Solna',
      'Huddinge',
      'Botkyrka',
      'Haninge',
      'Täby',
      'Sollentuna'
    ]
  },
  'Västra Götaland': {
    'cities': [
      'Gothenburg',
      'Borås',
      'Mölndal',
      'Trollhättan',
      'Skövde',
      'Uddevalla',
      'Lidköping',
      'Alingsås',
      'Lerum',
      'Kungälv'
    ]
  },
  'Skåne': {
    'cities': [
      'Malmö',
      'Helsingborg',
      'Lund',
      'Kristianstad',
      'Landskrona',
      'Trelleborg',
      'Ängelholm',
      'Eslöv',
      'Ystad',
      'Hässleholm'
    ]
  },

  // SWITZERLAND
  'Zürich': {
    'cities': [
      'Zürich',
      'Winterthur',
      'Uster',
      'Dübendorf',
      'Dietikon',
      'Wetzikon',
      'Wädenswil',
      'Horgen',
      'Kloten',
      'Bülach'
    ]
  },
  'Geneva': {
    'cities': [
      'Geneva',
      'Vernier',
      'Lancy',
      'Meyrin',
      'Carouge',
      'Onex',
      'Thônex',
      'Versoix',
      'Grand-Saconnex',
      'Chêne-Bougeries'
    ]
  },
  'Bern': {
    'cities': [
      'Bern',
      'Biel/Bienne',
      'Thun',
      'Köniz',
      'Burgdorf',
      'Steffisburg',
      'Ostermundigen',
      'Langenthal',
      'Münchenbuchsee',
      'Worb'
    ]
  },

  // ARGENTINA
  'Buenos Aires': {
    'cities': [
      'La Plata',
      'Mar del Plata',
      'Bahía Blanca',
      'Quilmes',
      'Merlo',
      'San Isidro',
      'Lanús',
      'Morón',
      'Avellaneda',
      'Tandil'
    ]
  },
  'Córdoba': {
    'cities': [
      'Córdoba',
      'Villa María',
      'Río Cuarto',
      'San Francisco',
      'Alta Gracia',
      'Río Tercero',
      'Bell Ville',
      'Villa Carlos Paz',
      'Jesús María',
      'Dean Funes'
    ]
  },
  'Santa Fe': {
    'cities': [
      'Rosario',
      'Santa Fe',
      'Rafaela',
      'Venado Tuerto',
      'Reconquista',
      'Santo Tomé',
      'Villa Gobernador Gálvez',
      'San Lorenzo',
      'Esperanza',
      'Casilda'
    ]
  },

  // NEW ZEALAND
  'Auckland': {
    'cities': [
      'Auckland CBD',
      'North Shore',
      'Manukau',
      'Waitakere',
      'Papakura',
      'Henderson',
      'Takapuna',
      'Howick',
      'New Lynn',
      'Panmure'
    ]
  },
  'Wellington': {
    'cities': [
      'Wellington City',
      'Lower Hutt',
      'Upper Hutt',
      'Porirua',
      'Kapiti',
      'Masterton',
      'Carterton',
      'Featherston',
      'Greytown',
      'Martinborough'
    ]
  },
  'Canterbury': {
    'cities': [
      'Christchurch',
      'Timaru',
      'Ashburton',
      'Rangiora',
      'Rolleston',
      'Kaiapoi',
      'Lincoln',
      'Geraldine',
      'Temuka',
      'Methven'
    ]
  },

  // SOUTH AFRICA
  'Gauteng': {
    'cities': [
      'Johannesburg',
      'Pretoria',
      'Ekurhuleni',
      'Centurion',
      'Soweto',
      'Benoni',
      'Springs',
      'Germiston',
      'Roodepoort',
      'Boksburg'
    ]
  },
  'Western Cape': {
    'cities': [
      'Cape Town',
      'Stellenbosch',
      'George',
      'Paarl',
      'Worcester',
      'Mossel Bay',
      'Oudtshoorn',
      'Hermanus',
      'Knysna',
      'Vredenburg'
    ]
  },
  'KwaZulu-Natal': {
    'cities': [
      'Durban',
      'Pietermaritzburg',
      'Newcastle',
      'Richards Bay',
      'Ladysmith',
      'Port Shepstone',
      'Ballito',
      'Empangeni',
      'Dundee',
      'Eshowe'
    ]
  },

  'Abia': {
    'cities': [
      'Umuahia',
      'Aba',
      'Ohafia',
      'Arochukwu',
      'Bende',
      'Isuikwuato',
      'Ukwa',
      'Uzuakoli',
      'Abiriba',
      'Nkporo'
    ]
  },
  'Adamawa': {
    'cities': [
      'Yola',
      'Mubi',
      'Numan',
      'Jimeta',
      'Ganye',
      'Mayo-Belwa',
      'Hong',
      'Gombi',
      'Michika',
      'Fufore'
    ]
  },
  'Akwa Ibom': {
    'cities': [
      'Uyo',
      'Eket',
      'Ikot Ekpene',
      'Oron',
      'Abak',
      'Ikot Abasi',
      'Etinan',
      'Ibiono',
      'Itu',
      'Mkpat Enin'
    ]
  },
  'Anambra': {
    'cities': [
      'Awka',
      'Onitsha',
      'Nnewi',
      'Ekwulobia',
      'Ihiala',
      'Aguata',
      'Orumba',
      'Ogidi',
      'Otuocha',
      'Umunze'
    ]
  },
  'Bauchi': {
    'cities': [
      'Bauchi',
      'Azare',
      'Misau',
      'Jama\'are',
      'Katagum',
      'Gambaki',
      'Dass',
      'Tafawa Balewa',
      'Alkaleri',
      'Toro'
    ]
  },
  'Bayelsa': {
    'cities': [
      'Yenagoa',
      'Brass',
      'Nembe',
      'Ogbia',
      'Sagbama',
      'Oporoma',
      'Kaiama',
      'Amassoma',
      'Twon-Brass',
      'Ekeremor'
    ]
  },
  'Benue': {
    'cities': [
      'Makurdi',
      'Otukpo',
      'Gboko',
      'Katsina-Ala',
      'Zaki Biam',
      'Vandeikya',
      'Adikpo',
      'Ugbokolo',
      'Buruku',
      'Naka'
    ]
  },
  'Borno': {
    'cities': [
      'Maiduguri',
      'Biu',
      'Gwoza',
      'Bama',
      'Dikwa',
      'Monguno',
      'Damboa',
      'Konduga',
      'Kukawa',
      'Ngala'
    ]
  },
  'Cross River': {
    'cities': [
      'Calabar',
      'Ugep',
      'Ogoja',
      'Obudu',
      'Ikom',
      'Akamkpa',
      'Odukpani',
      'Akpabuyo',
      'Yakurr',
      'Boki'
    ]
  },
  'Delta': {
    'cities': [
      'Asaba',
      'Warri',
      'Sapele',
      'Ughelli',
      'Agbor',
      'Abraka',
      'Burutu',
      'Kwale',
      'Oleh',
      'Ozoro'
    ]
  },
  'Ebonyi': {
    'cities': [
      'Abakaliki',
      'Afikpo',
      'Onueke',
      'Ishiagu',
      'Uburu',
      'Ezzamgbo',
      'Unwana',
      'Ikwo',
      'Ezza',
      'Ohaukwu'
    ]
  },
  'Edo': {
    'cities': [
      'Benin City',
      'Auchi',
      'Ekpoma',
      'Igarra',
      'Uromi',
      'Ubiaja',
      'Irrua',
      'Sabongida-Ora',
      'Igueben',
      'Abudu'
    ]
  },
  'Ekiti': {
    'cities': [
      'Ado-Ekiti',
      'Ikere',
      'Oye',
      'Ijero',
      'Ikole',
      'Efon',
      'Emure',
      'Ise',
      'Omuo',
      'Ilawe'
    ]
  },
  'Enugu': {
    'cities': [
      'Enugu',
      'Nsukka',
      'Oji River',
      'Awgu',
      'Udi',
      'Agbani',
      'Nike',
      'Ninth Mile',
      'Obollo-Afor',
      'Aguobu-Owa'
    ]
  },
  'FCT Abuja': {
    'cities': [
      'Abuja',
      'Gwagwalada',
      'Kuje',
      'Bwari',
      'Kwali',
      'Abaji',
      'Kubwa',
      'Nyanya',
      'Karu',
      'Lugbe'
    ]
  },
  'Gombe': {
    'cities': [
      'Gombe',
      'Billiri',
      'Kaltungo',
      'Kumo',
      'Dukku',
      'Bajoga',
      'Talasse',
      'Funakaye',
      'Nafada',
      'Ashaka'
    ]
  },
  'Imo': {
    'cities': [
      'Owerri',
      'Orlu',
      'Okigwe',
      'Mbaise',
      'Oguta',
      'Nkwerre',
      'Mbano',
      'Ohaji',
      'Ikeduru',
      'Ahiazu'
    ]
  },
  'Jigawa': {
    'cities': [
      'Dutse',
      'Hadejia',
      'Gumel',
      'Kazaure',
      'Ringim',
      'Garki',
      'Kafin Hausa',
      'Birnin Kudu',
      'Jahun',
      'Maigatari'
    ]
  },
  'Kaduna': {
    'cities': [
      'Kaduna',
      'Zaria',
      'Kafanchan',
      'Kagoro',
      'Kachia',
      'Soba',
      'Makarfi',
      'Giwa',
      'Saminaka',
      'Ikara'
    ]
  },
  'Kano': {
    'cities': [
      'Kano',
      'Wudil',
      'Bichi',
      'Gwarzo',
      'Dambatta',
      'Karaye',
      'Rano',
      'Gaya',
      'Sumaila',
      'Kunchi'
    ]
  },
  'Katsina': {
    'cities': [
      'Katsina',
      'Funtua',
      'Daura',
      'Malumfashi',
      'Jibia',
      'Kankia',
      'Mani',
      'Dutsin-Ma',
      'Bakori',
      'Mashi'
    ]
  },
  'Kebbi': {
    'cities': [
      'Birnin Kebbi',
      'Argungu',
      'Yauri',
      'Zuru',
      'Jega',
      'Gwandu',
      'Bunza',
      'Koko',
      'Maiyama',
      'Dakingari'
    ]
  },
  'Kogi': {
    'cities': [
      'Lokoja',
      'Okene',
      'Idah',
      'Kabba',
      'Ankpa',
      'Anyigba',
      'Dekina',
      'Egbe',
      'Isanlu',
      'Ogaminana'
    ]
  },
  'Kwara': {
    'cities': [
      'Ilorin',
      'Offa',
      'Patigi',
      'Omu-Aran',
      'Jebba',
      'Share',
      'Lafiagi',
      'Erin-Ile',
      'Kaiama',
      'Ajasse Ipo'
    ]
  },
  'Lagos': {
    'cities': [
      'Ikeja',
      'Lagos Island',
      'Lekki',
      'Surulere',
      'Apapa',
      'Ikorodu',
      'Mushin',
      'Oshodi',
      'Yaba',
      'Ajah'
    ]
  },
  'Nasarawa': {
    'cities': [
      'Lafia',
      'Keffi',
      'Akwanga',
      'Nasarawa',
      'Doma',
      'Toto',
      'Keana',
      'Awe',
      'Wamba',
      'Kokona'
    ]
  },
  'Niger': {
    'cities': [
      'Minna',
      'Bida',
      'Suleja',
      'Kontagora',
      'Lapai',
      'New Bussa',
      'Kagara',
      'Agaie',
      'Kutigi',
      'Rijau'
    ]
  },
  'Ogun': {
    'cities': [
      'Abeokuta',
      'Sagamu',
      'Ijebu Ode',
      'Ilaro',
      'Ota',
      'Ifo',
      'Ewekoro',
      'Iperu',
      'Ago-Iwoye',
      'Ayetoro'
    ]
  },
  'Ondo': {
    'cities': [
      'Akure',
      'Owo',
      'Ondo',
      'Ore',
      'Ikare',
      'Okitipupa',
      'Idanre',
      'Ifon',
      'Igbokoda',
      'Ile-Oluji'
    ]
  },
  'Osun': {
    'cities': [
      'Osogbo',
      'Ile-Ife',
      'Ilesa',
      'Ede',
      'Iwo',
      'Ejigbo',
      'Ikirun',
      'Ila Orangun',
      'Ikire',
      'Ipetu-Ijesa'
    ]
  },
  'Oyo': {
    'cities': [
      'Ibadan',
      'Ogbomosho',
      'Oyo',
      'Iseyin',
      'Saki',
      'Igboho',
      'Eruwa',
      'Igbo-Ora',
      'Kisi',
      'Lalupon'
    ]
  },
  'Plateau': {
    'cities': [
      'Jos',
      'Bukuru',
      'Pankshin',
      'Shendam',
      'Langtang',
      'Mangu',
      'Barkin Ladi',
      'Bokkos',
      'Wase',
      'Kafanchan'
    ]
  },
  'Rivers': {
    'cities': [
      'Port Harcourt',
      'Bonny',
      'Eleme',
      'Opobo',
      'Okrika',
      'Oyigbo',
      'Ahoada',
      'Degema',
      'Omoku',
      'Buguma'
    ]
  },
  'Sokoto': {
    'cities': [
      'Sokoto',
      'Tambuwal',
      'Gwadabawa',
      'Rabah',
      'Wurno',
      'Binji',
      'Goronyo',
      'Gada',
      'Illela',
      'Isa'
    ]
  },
  'Taraba': {
    'cities': [
      'Jalingo',
      'Wukari',
      'Bali',
      'Takum',
      'Gembu',
      'Ibi',
      'Lau',
      'Karim Lamido',
      'Zing',
      'Sardauna'
    ]
  },
  'Yobe': {
    'cities': [
      'Damaturu',
      'Potiskum',
      'Gashua',
      'Geidam',
      'Nguru',
      'Buni Yadi',
      'Dapchi',
      'Gubja',
      'Yunusari',
      'Yusufari'
    ]
  },
  'Zamfara': {
    'cities': [
      'Gusau',
      'Kaura Namoda',
      'Talata Mafara',
      'Anka',
      'Gummi',
      'Bukkuyum',
      'Tsafe',
      'Bungudu',
      'Maradun',
      'Shinkafi'
    ]
  }
  // Add more states and cities as needed
};
