/*
Question: Which product categories generate the most revenue, and how do they compare on customer satisfaction (review scores)?
Joined product and order tables, aggregated revenue by category, and compared against average review scores
*/

SELECT 
    pc.product_category_name_english,
    SUM(o.price) AS total,
    AVG(ors.review_score) AS review_score
FROM
    order_items o
INNER JOIN products p ON o.product_id = p.product_id
INNER JOIN product_category_name_translation pc ON p.product_category_name = pc.product_category_name
INNER JOIN order_reviews ors ON o.order_id = ors.order_id

GROUP BY pc.product_category_name_english
ORDER BY total DESC

/*
OUTPUT:
[
  {
    "product_category_name_english": "health_beauty",
    "total": "1252404.85",
    "review_score": "4.1427682737169518"
  },
  {
    "product_category_name_english": "watches_gifts",
    "total": "1197565.48",
    "review_score": "4.0191596638655462"
  },
  {
    "product_category_name_english": "bed_bath_table",
    "total": "1040140.31",
    "review_score": "3.8956631049654305"
  },
  {
    "product_category_name_english": "sports_leisure",
    "total": "986848.92",
    "review_score": "4.1079861111111111"
  },
  {
    "product_category_name_english": "computers_accessories",
    "total": "914579.39",
    "review_score": "3.9308192126385527"
  },
  {
    "product_category_name_english": "furniture_decor",
    "total": "729864.42",
    "review_score": "3.9034929780338495"
  },
  {
    "product_category_name_english": "housewares",
    "total": "630058.22",
    "review_score": "4.0550194440443612"
  },
  {
    "product_category_name_english": "cool_stuff",
    "total": "629561.68",
    "review_score": "4.1463414634146341"
  },
  {
    "product_category_name_english": "auto",
    "total": "586669.90",
    "review_score": "4.0655115119867078"
  },
  {
    "product_category_name_english": "garden_tools",
    "total": "482946.89",
    "review_score": "4.0427350427350427"
  },
  {
    "product_category_name_english": "toys",
    "total": "479702.10",
    "review_score": "4.1586409190906869"
  },
  {
    "product_category_name_english": "baby",
    "total": "408716.75",
    "review_score": "4.0118110236220472"
  },
  {
    "product_category_name_english": "perfumery",
    "total": "398578.07",
    "review_score": "4.1619409529377375"
  },
  {
    "product_category_name_english": "telephony",
    "total": "320111.07",
    "review_score": "3.9468673898605269"
  },
  {
    "product_category_name_english": "office_furniture",
    "total": "272339.82",
    "review_score": "3.4931831653823355"
  },
  {
    "product_category_name_english": "stationery",
    "total": "229835.78",
    "review_score": "4.1938571998404467"
  },
  {
    "product_category_name_english": "computers",
    "total": "214198.13",
    "review_score": "4.1750000000000000"
  },
  {
    "product_category_name_english": "pet_shop",
    "total": "213522.92",
    "review_score": "4.1851469829809180"
  },
  {
    "product_category_name_english": "small_appliances",
    "total": "189594.18",
    "review_score": "4.1491875923190547"
  },
  {
    "product_category_name_english": "musical_instruments",
    "total": "188876.46",
    "review_score": "4.1525925925925926"
  },
  {
    "product_category_name_english": "electronics",
    "total": "156383.07",
    "review_score": "4.0374681702437250"
  },
  {
    "product_category_name_english": "consoles_games",
    "total": "155906.27",
    "review_score": "4.0230700976042591"
  },
  {
    "product_category_name_english": "fashion_bags_accessories",
    "total": "152836.42",
    "review_score": "4.1446787641000490"
  },
  {
    "product_category_name_english": "construction_tools_construction",
    "total": "143797.00",
    "review_score": "4.0529157667386609"
  },
  {
    "product_category_name_english": "luggage_accessories",
    "total": "139845.20",
    "review_score": "4.3152573529411765"
  },
  {
    "product_category_name_english": "home_appliances_2",
    "total": "113216.49",
    "review_score": "4.1428571428571429"
  },
  {
    "product_category_name_english": "home_appliances",
    "total": "82973.75",
    "review_score": "4.1724565756823821"
  },
  {
    "product_category_name_english": "home_construction",
    "total": "82877.47",
    "review_score": "3.9400000000000000"
  },
  {
    "product_category_name_english": "agro_industry_and_commerce",
    "total": "72530.47",
    "review_score": "4.0000000000000000"
  },
  {
    "product_category_name_english": "furniture_living_room",
    "total": "68245.60",
    "review_score": "3.9043824701195219"
  },
  {
    "product_category_name_english": "fixed_telephony",
    "total": "59023.02",
    "review_score": "3.6832061068702290"
  },
  {
    "product_category_name_english": "home_confort",
    "total": "58051.84",
    "review_score": "3.8298850574712644"
  },
  {
    "product_category_name_english": "air_conditioning",
    "total": "54330.06",
    "review_score": "3.9691780821917808"
  },
  {
    "product_category_name_english": "audio",
    "total": "50458.71",
    "review_score": "3.8254847645429363"
  },
  {
    "product_category_name_english": "small_appliances_home_oven_and_coffee",
    "total": "47445.71",
    "review_score": "4.3026315789473684"
  },
  {
    "product_category_name_english": "books_general_interest",
    "total": "46580.13",
    "review_score": "4.4462659380692168"
  },
  {
    "product_category_name_english": "kitchen_dining_laundry_garden_furniture",
    "total": "46204.47",
    "review_score": "3.9642857142857143"
  },
  {
    "product_category_name_english": "construction_tools_safety",
    "total": "40515.52",
    "review_score": "3.8445595854922280"
  },
  {
    "product_category_name_english": "construction_tools_lights",
    "total": "40478.23",
    "review_score": "4.0540540540540541"
  },
  {
    "product_category_name_english": "industry_commerce_and_business",
    "total": "39559.61",
    "review_score": "4.1015037593984962"
  },
  {
    "product_category_name_english": "food",
    "total": "28935.41",
    "review_score": "4.2181818181818182"
  },
  {
    "product_category_name_english": "market_place",
    "total": "28313.18",
    "review_score": "4.0194174757281553"
  },
  {
    "product_category_name_english": "costruction_tools_garden",
    "total": "25769.74",
    "review_score": "4.0541666666666667"
  },
  {
    "product_category_name_english": "art",
    "total": "24037.74",
    "review_score": "3.9371980676328502"
  },
  {
    "product_category_name_english": "fashion_shoes",
    "total": "23368.07",
    "review_score": "4.2337164750957854"
  },
  {
    "product_category_name_english": "drinks",
    "total": "22415.96",
    "review_score": "4.0477453580901857"
  },
  {
    "product_category_name_english": "signaling_and_security",
    "total": "21338.95",
    "review_score": "4.0862944162436548"
  },
  {
    "product_category_name_english": "furniture_bedroom",
    "total": "20278.78",
    "review_score": "4.1181818181818182"
  },
  {
    "product_category_name_english": "books_technical",
    "total": "19040.09",
    "review_score": "4.3684210526315789"
  },
  {
    "product_category_name_english": "costruction_tools_tools",
    "total": "15774.25",
    "review_score": "4.4444444444444444"
  },
  {
    "product_category_name_english": "food_drink",
    "total": "15245.47",
    "review_score": "4.3154121863799283"
  },
  {
    "product_category_name_english": "fashion_male_clothing",
    "total": "10602.82",
    "review_score": "3.6412213740458015"
  },
  {
    "product_category_name_english": "fashion_underwear_beach",
    "total": "9491.65",
    "review_score": "3.9769230769230769"
  },
  {
    "product_category_name_english": "christmas_supplies",
    "total": "8090.10",
    "review_score": "4.0205479452054795"
  },
  {
    "product_category_name_english": "cine_photo",
    "total": "6949.36",
    "review_score": "4.2054794520547945"
  },
  {
    "product_category_name_english": "tablets_printing_image",
    "total": "6508.43",
    "review_score": "4.1234567901234568"
  },
  {
    "product_category_name_english": "music",
    "total": "6034.35",
    "review_score": "4.2105263157894737"
  },
  {
    "product_category_name_english": "dvds_blu_ray",
    "total": "5982.49",
    "review_score": "4.0793650793650794"
  },
  {
    "product_category_name_english": "books_imported",
    "total": "4639.85",
    "review_score": "4.4000000000000000"
  },
  {
    "product_category_name_english": "party_supplies",
    "total": "4485.18",
    "review_score": "3.7674418604651163"
  },
  {
    "product_category_name_english": "furniture_mattress_and_upholstery",
    "total": "4368.08",
    "review_score": "3.8157894736842105"
  },
  {
    "product_category_name_english": "fashio_female_clothing",
    "total": "2889.44",
    "review_score": "3.7800000000000000"
  },
  {
    "product_category_name_english": "fashion_sport",
    "total": "2144.50",
    "review_score": "4.2580645161290323"
  },
  {
    "product_category_name_english": "la_cuisine",
    "total": "1917.99",
    "review_score": "4.0000000000000000"
  },
  {
    "product_category_name_english": "arts_and_craftmanship",
    "total": "1814.01",
    "review_score": "4.1250000000000000"
  },
  {
    "product_category_name_english": "diapers_and_hygiene",
    "total": "1567.59",
    "review_score": "3.2564102564102564"
  },
  {
    "product_category_name_english": "flowers",
    "total": "1000.24",
    "review_score": "4.4193548387096774"
  },
  {
    "product_category_name_english": "cds_dvds_musicals",
    "total": "730.0",
    "review_score": "4.6428571428571429"
  },
  {
    "product_category_name_english": "home_comfort_2",
    "total": "721.57",
    "review_score": "3.6296296296296296"
  },
  {
    "product_category_name_english": "fashion_childrens_clothes",
    "total": "569.85",
    "review_score": "4.5000000000000000"
  },
  {
    "product_category_name_english": "security_and_services",
    "total": "283.29",
    "review_score": "2.5000000000000000"
  }
]
*/