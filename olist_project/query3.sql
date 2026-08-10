/*
Question 3: Who are the top 5 spending customers in each state, and which states drive the most revenue overall?
Used RANK() PARTITION BY state on joined customer/order data to surface top spenders per state
*/

WITH total_spend AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        SUM(oi.price) AS total_amt,
        RANK() OVER (
            PARTITION BY c.customer_state
            ORDER BY SUM(oi.price) DESC
        ) AS customer_rank
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),
state_revenue AS (
    SELECT
        *,
        SUM(total_amt) OVER (
            PARTITION BY customer_state
        ) AS total_state_revenue
    FROM total_spend
)
SELECT *
FROM state_revenue
WHERE customer_rank <= 5
ORDER BY total_state_revenue DESC, customer_state, customer_rank;

/* 
OUTPUT:
[
  {
    "customer_unique_id": "ff4159b92c40ebe40454e3e6a7c35ed6",
    "customer_state": "SP",
    "total_amt": "6499.0",
    "customer_rank": "1",
    "total_state_revenue": "5067633.16"
  },
  {
    "customer_unique_id": "eebb5dda148d3893cdaf5b5ca3040ccb",
    "customer_state": "SP",
    "total_amt": "4690.0",
    "customer_rank": "2",
    "total_state_revenue": "5067633.16"
  },
  {
    "customer_unique_id": "edde2314c6c30e864a128ac95d6b2112",
    "customer_state": "SP",
    "total_amt": "4399.87",
    "customer_rank": "3",
    "total_state_revenue": "5067633.16"
  },
  {
    "customer_unique_id": "011875f0176909c5cf0b14a9138bb691",
    "customer_state": "SP",
    "total_amt": "3999.9",
    "customer_rank": "4",
    "total_state_revenue": "5067633.16"
  },
  {
    "customer_unique_id": "58483a1c055dfb600f57c5b867174542",
    "customer_state": "SP",
    "total_amt": "3899.0",
    "customer_rank": "5",
    "total_state_revenue": "5067633.16"
  },
  {
    "customer_unique_id": "0a0a92112bd4c708ca5fde585afaa872",
    "customer_state": "RJ",
    "total_amt": "13440.0",
    "customer_rank": "1",
    "total_state_revenue": "1759651.13"
  },
  {
    "customer_unique_id": "da122df9eeddfedc1dc1f5349a1a690c",
    "customer_state": "RJ",
    "total_amt": "7388.0",
    "customer_rank": "2",
    "total_state_revenue": "1759651.13"
  },
  {
    "customer_unique_id": "a229eba70ec1c2abef51f04987deb7a5",
    "customer_state": "RJ",
    "total_amt": "4400.0",
    "customer_rank": "3",
    "total_state_revenue": "1759651.13"
  },
  {
    "customer_unique_id": "f0767ae738c3d90e7b737d7b8b8bb4d1",
    "customer_state": "RJ",
    "total_amt": "3930.0",
    "customer_rank": "4",
    "total_state_revenue": "1759651.13"
  },
  {
    "customer_unique_id": "c6111f70f40b3420e387493c627c27fa",
    "customer_state": "RJ",
    "total_amt": "2999.99",
    "customer_rank": "5",
    "total_state_revenue": "1759651.13"
  },
  {
    "customer_unique_id": "4007669dec559734d6f53e029e360987",
    "customer_state": "MG",
    "total_amt": "5934.6",
    "customer_rank": "1",
    "total_state_revenue": "1552481.83"
  },
  {
    "customer_unique_id": "fa562ef24d41361e476e748681810e1e",
    "customer_state": "MG",
    "total_amt": "4099.99",
    "customer_rank": "2",
    "total_state_revenue": "1552481.83"
  },
  {
    "customer_unique_id": "ca27f3dac28fb1063faddd424c9d95fa",
    "customer_state": "MG",
    "total_amt": "4059.0",
    "customer_rank": "3",
    "total_state_revenue": "1552481.83"
  },
  {
    "customer_unique_id": "bc5e25094a7d51b6aee35236572e64f4",
    "customer_state": "MG",
    "total_amt": "3690.0",
    "customer_rank": "4",
    "total_state_revenue": "1552481.83"
  },
  {
    "customer_unique_id": "53fb3435773a4690e56010b169ee2820",
    "customer_state": "MG",
    "total_amt": "3099.9",
    "customer_rank": "5",
    "total_state_revenue": "1552481.83"
  },
  {
    "customer_unique_id": "c8460e4251689ba205045f3ea17884a1",
    "customer_state": "RS",
    "total_amt": "4080.0",
    "customer_rank": "1",
    "total_state_revenue": "728897.47"
  },
  {
    "customer_unique_id": "7a96eb0a685f5c19b7dad29fc802aa64",
    "customer_state": "RS",
    "total_amt": "3124.0",
    "customer_rank": "2",
    "total_state_revenue": "728897.47"
  },
  {
    "customer_unique_id": "8e07cbdbbb24328ece74135e2a81405b",
    "customer_state": "RS",
    "total_amt": "2350.0",
    "customer_rank": "3",
    "total_state_revenue": "728897.47"
  },
  {
    "customer_unique_id": "86df00dc5fd68f4dd5d5945ca19f3ed6",
    "customer_state": "RS",
    "total_amt": "2200.0",
    "customer_rank": "4",
    "total_state_revenue": "728897.47"
  },
  {
    "customer_unique_id": "bd8717655febcdf30f106e9f3cb24628",
    "customer_state": "RS",
    "total_amt": "2199.99",
    "customer_rank": "5",
    "total_state_revenue": "728897.47"
  },
  {
    "customer_unique_id": "895617ab63a9ad8881d9470f7427cd25",
    "customer_state": "PR",
    "total_amt": "2999.99",
    "customer_rank": "1",
    "total_state_revenue": "666063.51"
  },
  {
    "customer_unique_id": "c21e93b1d7b7a416d0f36fa6ebc1d60a",
    "customer_state": "PR",
    "total_amt": "2799.0",
    "customer_rank": "2",
    "total_state_revenue": "666063.51"
  },
  {
    "customer_unique_id": "f140f377d666848e3712b51a2734d120",
    "customer_state": "PR",
    "total_amt": "2338.08",
    "customer_rank": "3",
    "total_state_revenue": "666063.51"
  },
  {
    "customer_unique_id": "c01158adcf91ee8f143d12388abe5f22",
    "customer_state": "PR",
    "total_amt": "2299.99",
    "customer_rank": "4",
    "total_state_revenue": "666063.51"
  },
  {
    "customer_unique_id": "87070b00f89fa49dd0b01ff4bf075b8c",
    "customer_state": "PR",
    "total_amt": "2299.95",
    "customer_rank": "5",
    "total_state_revenue": "666063.51"
  },
  {
    "customer_unique_id": "931eabdf0636b8fd60369a8d759917d6",
    "customer_state": "SC",
    "total_amt": "3597.0",
    "customer_rank": "1",
    "total_state_revenue": "507012.13"
  },
  {
    "customer_unique_id": "46450c74a0d8c5ca9395da1daac6c120",
    "customer_state": "SC",
    "total_amt": "3109.99",
    "customer_rank": "2",
    "total_state_revenue": "507012.13"
  },
  {
    "customer_unique_id": "bbeb907759ef5fc169099af3c88d535d",
    "customer_state": "SC",
    "total_amt": "3105.0",
    "customer_rank": "3",
    "total_state_revenue": "507012.13"
  },
  {
    "customer_unique_id": "129bfc164612d70a040a844b887dfec5",
    "customer_state": "SC",
    "total_amt": "2899.0",
    "customer_rank": "4",
    "total_state_revenue": "507012.13"
  },
  {
    "customer_unique_id": "4683ad127301c1bcbd601a30bb22d2ba",
    "customer_state": "SC",
    "total_amt": "2699.0",
    "customer_rank": "5",
    "total_state_revenue": "507012.13"
  },
  {
    "customer_unique_id": "76a08544f95591acec0d4c976054c459",
    "customer_state": "BA",
    "total_amt": "3300.0",
    "customer_rank": "1",
    "total_state_revenue": "493584.14"
  },
  {
    "customer_unique_id": "ff0ae98646e7bbb41cf0f0d3991fef98",
    "customer_state": "BA",
    "total_amt": "2999.89",
    "customer_rank": "2",
    "total_state_revenue": "493584.14"
  },
  {
    "customer_unique_id": "ae04948ad7210ea76801b331080e0b3a",
    "customer_state": "BA",
    "total_amt": "2951.0",
    "customer_rank": "3",
    "total_state_revenue": "493584.14"
  },
  {
    "customer_unique_id": "be825ddd3b40db3f91bf05b4e9435d56",
    "customer_state": "BA",
    "total_amt": "2920.0",
    "customer_rank": "4",
    "total_state_revenue": "493584.14"
  },
  {
    "customer_unique_id": "acc38a550c42d17125cd25c32a464d26",
    "customer_state": "BA",
    "total_amt": "2689.0",
    "customer_rank": "5",
    "total_state_revenue": "493584.14"
  },
  {
    "customer_unique_id": "edf81e1f3070b9dac83ec83dacdbb9bc",
    "customer_state": "DF",
    "total_amt": "3999.0",
    "customer_rank": "1",
    "total_state_revenue": "296498.41"
  },
  {
    "customer_unique_id": "5d09b0d82126457e2a8ebfb9c9a1ffc4",
    "customer_state": "DF",
    "total_amt": "3699.99",
    "customer_rank": "2",
    "total_state_revenue": "296498.41"
  },
  {
    "customer_unique_id": "03796b63235e0e0a299084988c662c7e",
    "customer_state": "DF",
    "total_amt": "3549.0",
    "customer_rank": "3",
    "total_state_revenue": "296498.41"
  },
  {
    "customer_unique_id": "8ad6fdb3d658f916f444aaf55a49bb29",
    "customer_state": "DF",
    "total_amt": "2699.0",
    "customer_rank": "4",
    "total_state_revenue": "296498.41"
  },
  {
    "customer_unique_id": "684da9ec00ee25877fe21ce197403d04",
    "customer_state": "DF",
    "total_amt": "2550.0",
    "customer_rank": "5",
    "total_state_revenue": "296498.41"
  },
  {
    "customer_unique_id": "030a810edeec1ceea314282513023587",
    "customer_state": "GO",
    "total_amt": "2740.0",
    "customer_rank": "1",
    "total_state_revenue": "282836.70"
  },
  {
    "customer_unique_id": "fa094305fdb6062436c99adba7d53dde",
    "customer_state": "GO",
    "total_amt": "2198.0",
    "customer_rank": "2",
    "total_state_revenue": "282836.70"
  },
  {
    "customer_unique_id": "9d15276f07200ca33bdd7eab12ba67ad",
    "customer_state": "GO",
    "total_amt": "2170.0",
    "customer_rank": "3",
    "total_state_revenue": "282836.70"
  },
  {
    "customer_unique_id": "e8258022c5060b1f3d861556a17fd741",
    "customer_state": "GO",
    "total_amt": "2029.0",
    "customer_rank": "4",
    "total_state_revenue": "282836.70"
  },
  {
    "customer_unique_id": "698e1cf81d01a3d389d96145f7fa6df8",
    "customer_state": "GO",
    "total_amt": "1974.0",
    "customer_rank": "5",
    "total_state_revenue": "282836.70"
  },
  {
    "customer_unique_id": "763c8b1c9c68a0229c42c9fc6f662b93",
    "customer_state": "ES",
    "total_amt": "7160.0",
    "customer_rank": "1",
    "total_state_revenue": "268643.45"
  },
  {
    "customer_unique_id": "459bef486812aa25204be022145caa62",
    "customer_state": "ES",
    "total_amt": "6729.0",
    "customer_rank": "2",
    "total_state_revenue": "268643.45"
  },
  {
    "customer_unique_id": "1a3d1e8b28c0ee27c23333ee108c47e6",
    "customer_state": "ES",
    "total_amt": "1880.0",
    "customer_rank": "3",
    "total_state_revenue": "268643.45"
  },
  {
    "customer_unique_id": "c40698869e63dc7c57f3f66e767e7287",
    "customer_state": "ES",
    "total_amt": "1775.78",
    "customer_rank": "4",
    "total_state_revenue": "268643.45"
  },
  {
    "customer_unique_id": "ac0ec8bdce394d27bc6c91549f2b5091",
    "customer_state": "ES",
    "total_amt": "1699.99",
    "customer_rank": "5",
    "total_state_revenue": "268643.45"
  },
  {
    "customer_unique_id": "3fec1a05177762f279472253113d568a",
    "customer_state": "PE",
    "total_amt": "3700.0",
    "customer_rank": "1",
    "total_state_revenue": "251889.49"
  },
  {
    "customer_unique_id": "6f00d356a4be20527662aaf12116baab",
    "customer_state": "PE",
    "total_amt": "2990.0",
    "customer_rank": "2",
    "total_state_revenue": "251889.49"
  },
  {
    "customer_unique_id": "918c2334c6537fd745c6aea1e3fe54f8",
    "customer_state": "PE",
    "total_amt": "1999.0",
    "customer_rank": "3",
    "total_state_revenue": "251889.49"
  },
  {
    "customer_unique_id": "5e5a9e721cb83187f5893a8c7109faee",
    "customer_state": "PE",
    "total_amt": "1989.0",
    "customer_rank": "4",
    "total_state_revenue": "251889.49"
  },
  {
    "customer_unique_id": "e650a740f366df1d65e17eeda8cccb43",
    "customer_state": "PE",
    "total_amt": "1899.12",
    "customer_rank": "5",
    "total_state_revenue": "251889.49"
  },
  {
    "customer_unique_id": "149b43a4776ea0a773ac75bc58830fb9",
    "customer_state": "CE",
    "total_amt": "2690.0",
    "customer_rank": "1",
    "total_state_revenue": "219757.38"
  },
  {
    "customer_unique_id": "1a3a962a15f8c6ee0178e1102387d3cc",
    "customer_state": "CE",
    "total_amt": "2139.99",
    "customer_rank": "2",
    "total_state_revenue": "219757.38"
  },
  {
    "customer_unique_id": "ac32c69c438fa163767f5aa5c4d0b6e1",
    "customer_state": "CE",
    "total_amt": "1890.0",
    "customer_rank": "3",
    "total_state_revenue": "219757.38"
  },
  {
    "customer_unique_id": "9654d6df6a63f5a9b61dd5ba0e0d8286",
    "customer_state": "CE",
    "total_amt": "1790.0",
    "customer_rank": "4",
    "total_state_revenue": "219757.38"
  },
  {
    "customer_unique_id": "1ee27e3ae93ad59224094a4ea0c71dc2",
    "customer_state": "CE",
    "total_amt": "1699.0",
    "customer_rank": "5",
    "total_state_revenue": "219757.38"
  },
  {
    "customer_unique_id": "5e713be0853d8986528d7869a0811d2b",
    "customer_state": "PA",
    "total_amt": "3980.0",
    "customer_rank": "1",
    "total_state_revenue": "174470.59"
  },
  {
    "customer_unique_id": "e79c794eb044c594d923722240125052",
    "customer_state": "PA",
    "total_amt": "2199.0",
    "customer_rank": "2",
    "total_state_revenue": "174470.59"
  },
  {
    "customer_unique_id": "0b8f48c242246419f92b6c43b0165010",
    "customer_state": "PA",
    "total_amt": "1599.0",
    "customer_rank": "3",
    "total_state_revenue": "174470.59"
  },
  {
    "customer_unique_id": "ffba9f9dff87b05e310ecc46c8591044",
    "customer_state": "PA",
    "total_amt": "1591.2",
    "customer_rank": "4",
    "total_state_revenue": "174470.59"
  },
  {
    "customer_unique_id": "f94c00f0411b6a3e6cbde94b120fb786",
    "customer_state": "PA",
    "total_amt": "1500.0",
    "customer_rank": "5",
    "total_state_revenue": "174470.59"
  },
  {
    "customer_unique_id": "adfa1cab2b2c8706db21bb13c0a1beb1",
    "customer_state": "MT",
    "total_amt": "2919.4",
    "customer_rank": "1",
    "total_state_revenue": "152191.62"
  },
  {
    "customer_unique_id": "84056c11d63b679a61f195ef043505f4",
    "customer_state": "MT",
    "total_amt": "2399.8",
    "customer_rank": "2",
    "total_state_revenue": "152191.62"
  },
  {
    "customer_unique_id": "afc8f3a11a809a74e5eef0bda1de6b9c",
    "customer_state": "MT",
    "total_amt": "1890.0",
    "customer_rank": "3",
    "total_state_revenue": "152191.62"
  },
  {
    "customer_unique_id": "3a205021b542565ebf170c0ec55783d9",
    "customer_state": "MT",
    "total_amt": "1736.0",
    "customer_rank": "4",
    "total_state_revenue": "152191.62"
  },
  {
    "customer_unique_id": "2c32247bb780398fedc970dfa0832e25",
    "customer_state": "MT",
    "total_amt": "1704.97",
    "customer_rank": "5",
    "total_state_revenue": "152191.62"
  },
  {
    "customer_unique_id": "1b76903617af13189607a36b0469f6f3",
    "customer_state": "MA",
    "total_amt": "3099.75",
    "customer_rank": "1",
    "total_state_revenue": "117009.38"
  },
  {
    "customer_unique_id": "c53a15252bb69a238a59b79c58a84bcf",
    "customer_state": "MA",
    "total_amt": "2199.0",
    "customer_rank": "2",
    "total_state_revenue": "117009.38"
  },
  {
    "customer_unique_id": "079ad4f138ec38e726e7d9ac51ae1410",
    "customer_state": "MA",
    "total_amt": "1635.0",
    "customer_rank": "3",
    "total_state_revenue": "117009.38"
  },
  {
    "customer_unique_id": "67031f3c7bc5f28dd7b6344294b4ffec",
    "customer_state": "MA",
    "total_amt": "1599.99",
    "customer_rank": "4",
    "total_state_revenue": "117009.38"
  },
  {
    "customer_unique_id": "ae06b0187a99aaeb5e845b9638936e7d",
    "customer_state": "MA",
    "total_amt": "1437.0",
    "customer_rank": "5",
    "total_state_revenue": "117009.38"
  },
  {
    "customer_unique_id": "dc4802a71eae9be1dd28f5d788ceb526",
    "customer_state": "MS",
    "total_amt": "6735.0",
    "customer_rank": "1",
    "total_state_revenue": "115429.97"
  },
  {
    "customer_unique_id": "0f75637a7e2f7b6ae43665d1f7d0ca5d",
    "customer_state": "MS",
    "total_amt": "2999.89",
    "customer_rank": "2",
    "total_state_revenue": "115429.97"
  },
  {
    "customer_unique_id": "8a8a3b96590da699865fa7e07e0e08ff",
    "customer_state": "MS",
    "total_amt": "2062.99",
    "customer_rank": "3",
    "total_state_revenue": "115429.97"
  },
  {
    "customer_unique_id": "3d81d4e0977945889ce7eee309a884c5",
    "customer_state": "MS",
    "total_amt": "1899.0",
    "customer_rank": "4",
    "total_state_revenue": "115429.97"
  },
  {
    "customer_unique_id": "fac9eb2c3c550f64f779646726710b59",
    "customer_state": "MS",
    "total_amt": "1599.0",
    "customer_rank": "5",
    "total_state_revenue": "115429.97"
  },
  {
    "customer_unique_id": "48e1ac109decbb87765a3eade6854098",
    "customer_state": "PB",
    "total_amt": "4590.0",
    "customer_rank": "1",
    "total_state_revenue": "112586.82"
  },
  {
    "customer_unique_id": "95a744604de66a2e40e18086e69be4f2",
    "customer_state": "PB",
    "total_amt": "3089.0",
    "customer_rank": "2",
    "total_state_revenue": "112586.82"
  },
  {
    "customer_unique_id": "85475e754525d6d222d917dbc8251801",
    "customer_state": "PB",
    "total_amt": "2399.0",
    "customer_rank": "3",
    "total_state_revenue": "112586.82"
  },
  {
    "customer_unique_id": "8bce6306eb006a2ff6135ba36d33d644",
    "customer_state": "PB",
    "total_amt": "2200.0",
    "customer_rank": "4",
    "total_state_revenue": "112586.82"
  },
  {
    "customer_unique_id": "e0a7e61d37dd4060ab419bdb93a9f05d",
    "customer_state": "PB",
    "total_amt": "2090.0",
    "customer_rank": "5",
    "total_state_revenue": "112586.82"
  },
  {
    "customer_unique_id": "a7ca51c5d161c34444a45ff503b78b0c",
    "customer_state": "PI",
    "total_amt": "1797.0",
    "customer_rank": "1",
    "total_state_revenue": "84721.00"
  },
  {
    "customer_unique_id": "66b219a06a37d7129406e32d295a46fb",
    "customer_state": "PI",
    "total_amt": "1780.0",
    "customer_rank": "2",
    "total_state_revenue": "84721.00"
  },
  {
    "customer_unique_id": "9fc8316f4c0d0601664216e0a9327ed5",
    "customer_state": "PI",
    "total_amt": "1695.0",
    "customer_rank": "3",
    "total_state_revenue": "84721.00"
  },
  {
    "customer_unique_id": "b045295488236fa73d8d9c37dc4b03e7",
    "customer_state": "PI",
    "total_amt": "1174.98",
    "customer_rank": "4",
    "total_state_revenue": "84721.00"
  },
  {
    "customer_unique_id": "41ef6bfcee3f50fe3d886cf23a0e2481",
    "customer_state": "PI",
    "total_amt": "1099.0",
    "customer_rank": "5",
    "total_state_revenue": "84721.00"
  },
  {
    "customer_unique_id": "589acbf5a83a1545b7b1956065ac2fa7",
    "customer_state": "PI",
    "total_amt": "1099.0",
    "customer_rank": "5",
    "total_state_revenue": "84721.00"
  },
  {
    "customer_unique_id": "6ae98e2bdf8d09e86cd16479fa511f9e",
    "customer_state": "RN",
    "total_amt": "1788.0",
    "customer_rank": "1",
    "total_state_revenue": "82105.66"
  },
  {
    "customer_unique_id": "38e482d7770a43f5929378c4dec76d5e",
    "customer_state": "RN",
    "total_amt": "1750.0",
    "customer_rank": "2",
    "total_state_revenue": "82105.66"
  },
  {
    "customer_unique_id": "c11f76d3806da64a4c64ea47627444e2",
    "customer_state": "RN",
    "total_amt": "1727.0",
    "customer_rank": "3",
    "total_state_revenue": "82105.66"
  },
  {
    "customer_unique_id": "0a247a228e8d48fc8afbc28c2e8c1691",
    "customer_state": "RN",
    "total_amt": "1299.9",
    "customer_rank": "4",
    "total_state_revenue": "82105.66"
  },
  {
    "customer_unique_id": "1159db37e256a4e27f777ebd08b4da05",
    "customer_state": "RN",
    "total_amt": "1299.65",
    "customer_rank": "5",
    "total_state_revenue": "82105.66"
  },
  {
    "customer_unique_id": "03adb96012772d4374285b6a701f3da9",
    "customer_state": "AL",
    "total_amt": "2159.98",
    "customer_rank": "1",
    "total_state_revenue": "78855.72"
  },
  {
    "customer_unique_id": "9b661514ad84d0489ac73d9e24cbf169",
    "customer_state": "AL",
    "total_amt": "1798.0",
    "customer_rank": "2",
    "total_state_revenue": "78855.72"
  },
  {
    "customer_unique_id": "87c9e7ba960e4c2e6bd786b162adc639",
    "customer_state": "AL",
    "total_amt": "1597.8",
    "customer_rank": "3",
    "total_state_revenue": "78855.72"
  },
  {
    "customer_unique_id": "3d16152c514410c047904cd433439892",
    "customer_state": "AL",
    "total_amt": "1597.35",
    "customer_rank": "4",
    "total_state_revenue": "78855.72"
  },
  {
    "customer_unique_id": "5a1f8efaa6ce666e9622bf2e22c42aac",
    "customer_state": "AL",
    "total_amt": "1595.0",
    "customer_rank": "5",
    "total_state_revenue": "78855.72"
  },
  {
    "customer_unique_id": "2f0ce2fb407114dbfa866f22c7cf9e9d",
    "customer_state": "SE",
    "total_amt": "1670.0",
    "customer_rank": "1",
    "total_state_revenue": "56574.19"
  },
  {
    "customer_unique_id": "79e12483f9b14c3254db94bd137a4b70",
    "customer_state": "SE",
    "total_amt": "1349.0",
    "customer_rank": "2",
    "total_state_revenue": "56574.19"
  },
  {
    "customer_unique_id": "8be5c6cc1011c8a882d3bac857955b3d",
    "customer_state": "SE",
    "total_amt": "1314.99",
    "customer_rank": "3",
    "total_state_revenue": "56574.19"
  },
  {
    "customer_unique_id": "3e45a109987cde39a119cd1a7eade7ea",
    "customer_state": "SE",
    "total_amt": "1200.0",
    "customer_rank": "4",
    "total_state_revenue": "56574.19"
  },
  {
    "customer_unique_id": "7fe33c78f78af66702aa8acdd82ffb55",
    "customer_state": "SE",
    "total_amt": "1155.0",
    "customer_rank": "5",
    "total_state_revenue": "56574.19"
  },
  {
    "customer_unique_id": "81d8bf17c9e450228efeedd2603edfaa",
    "customer_state": "TO",
    "total_amt": "2649.99",
    "customer_rank": "1",
    "total_state_revenue": "48402.51"
  },
  {
    "customer_unique_id": "92ce8d58d57d7a8f8b2d5ca4b9810b64",
    "customer_state": "TO",
    "total_amt": "1999.0",
    "customer_rank": "2",
    "total_state_revenue": "48402.51"
  },
  {
    "customer_unique_id": "985289b5cb474a6e97bfe8c85f0aee74",
    "customer_state": "TO",
    "total_amt": "1380.0",
    "customer_rank": "3",
    "total_state_revenue": "48402.51"
  },
  {
    "customer_unique_id": "cbbe4b5beeea8b05dae43cfd1a73e6d9",
    "customer_state": "TO",
    "total_amt": "1200.0",
    "customer_rank": "4",
    "total_state_revenue": "48402.51"
  },
  {
    "customer_unique_id": "38d92612568ca6e3d6b478e5fb004a6f",
    "customer_state": "TO",
    "total_amt": "999.99",
    "customer_rank": "5",
    "total_state_revenue": "48402.51"
  },
  {
    "customer_unique_id": "d3ef55d6de8e4be1d4b905e8169224b5",
    "customer_state": "RO",
    "total_amt": "2400.0",
    "customer_rank": "1",
    "total_state_revenue": "45682.76"
  },
  {
    "customer_unique_id": "c705e3b98b76bd8e56d09625ac94216a",
    "customer_state": "RO",
    "total_amt": "1999.0",
    "customer_rank": "2",
    "total_state_revenue": "45682.76"
  },
  {
    "customer_unique_id": "fad1bbf902fbdf64f92f33d010ab8cb7",
    "customer_state": "RO",
    "total_amt": "1429.9",
    "customer_rank": "3",
    "total_state_revenue": "45682.76"
  },
  {
    "customer_unique_id": "5d1fde9eb27149c695624f8bb84cf6f7",
    "customer_state": "RO",
    "total_amt": "1319.9",
    "customer_rank": "4",
    "total_state_revenue": "45682.76"
  },
  {
    "customer_unique_id": "69d93815c9ea08e83377d78cb088a295",
    "customer_state": "RO",
    "total_amt": "1299.9",
    "customer_rank": "5",
    "total_state_revenue": "45682.76"
  },
  {
    "customer_unique_id": "23841d4abf4583dec7773f3bd2fe267d",
    "customer_state": "AM",
    "total_amt": "1688.0",
    "customer_rank": "1",
    "total_state_revenue": "22155.84"
  },
  {
    "customer_unique_id": "64b97e6d3c070dd372d6310ff2c632f7",
    "customer_state": "AM",
    "total_amt": "1340.0",
    "customer_rank": "2",
    "total_state_revenue": "22155.84"
  },
  {
    "customer_unique_id": "3246cc1ffb8b0e719e5ba4db0443185d",
    "customer_state": "AM",
    "total_amt": "1190.65",
    "customer_rank": "3",
    "total_state_revenue": "22155.84"
  },
  {
    "customer_unique_id": "dff33bfc45ae0becc55ce9b50acd4073",
    "customer_state": "AM",
    "total_amt": "965.8",
    "customer_rank": "4",
    "total_state_revenue": "22155.84"
  },
  {
    "customer_unique_id": "f50b0ade21665c5b41d8d1db10ef9932",
    "customer_state": "AM",
    "total_amt": "699.99",
    "customer_rank": "5",
    "total_state_revenue": "22155.84"
  },
  {
    "customer_unique_id": "62a459e5629b03dd73134964df732077",
    "customer_state": "AC",
    "total_amt": "1200.0",
    "customer_rank": "1",
    "total_state_revenue": "15930.97"
  },
  {
    "customer_unique_id": "086d6b5b5ba195a91aa0a6ec8e75d1a4",
    "customer_state": "AC",
    "total_amt": "961.6",
    "customer_rank": "2",
    "total_state_revenue": "15930.97"
  },
  {
    "customer_unique_id": "3947ca729a860c522a64a49d762baada",
    "customer_state": "AC",
    "total_amt": "839.99",
    "customer_rank": "3",
    "total_state_revenue": "15930.97"
  },
  {
    "customer_unique_id": "3e5c928acf49c4b95e57af1f350d3493",
    "customer_state": "AC",
    "total_amt": "809.1",
    "customer_rank": "4",
    "total_state_revenue": "15930.97"
  },
  {
    "customer_unique_id": "28989ef45087c96e5a4346e88216c2ba",
    "customer_state": "AC",
    "total_amt": "589.6",
    "customer_rank": "5",
    "total_state_revenue": "15930.97"
  },
  {
    "customer_unique_id": "7a44821edf14b2b2ef3ffb2c6e837e5b",
    "customer_state": "AP",
    "total_amt": "1437.0",
    "customer_rank": "1",
    "total_state_revenue": "13374.81"
  },
  {
    "customer_unique_id": "f03553cc2a5d9a0d2b945ccf7f4c54bc",
    "customer_state": "AP",
    "total_amt": "1358.24",
    "customer_rank": "2",
    "total_state_revenue": "13374.81"
  },
  {
    "customer_unique_id": "6f932f011a8e866d632f58cc7580a7f5",
    "customer_state": "AP",
    "total_amt": "949.9",
    "customer_rank": "3",
    "total_state_revenue": "13374.81"
  },
  {
    "customer_unique_id": "b3eb76b315600c9f8c3a711b6a3d1668",
    "customer_state": "AP",
    "total_amt": "798.0",
    "customer_rank": "4",
    "total_state_revenue": "13374.81"
  },
  {
    "customer_unique_id": "1f14cece5da31d108e380c174f68f552",
    "customer_state": "AP",
    "total_amt": "589.99",
    "customer_rank": "5",
    "total_state_revenue": "13374.81"
  },
  {
    "customer_unique_id": "858ec48dbaddd52e729e8acdc8d2d108",
    "customer_state": "RR",
    "total_amt": "949.9",
    "customer_rank": "1",
    "total_state_revenue": "7057.47"
  },
  {
    "customer_unique_id": "660faf14e9201af9e1c4f65968010944",
    "customer_state": "RR",
    "total_amt": "699.0",
    "customer_rank": "2",
    "total_state_revenue": "7057.47"
  },
  {
    "customer_unique_id": "7d0983269f825d3112e5a64364b1258a",
    "customer_state": "RR",
    "total_amt": "595.9",
    "customer_rank": "3",
    "total_state_revenue": "7057.47"
  },
  {
    "customer_unique_id": "4df43d4c7d3a093a519dbfe0b9dcc0d6",
    "customer_state": "RR",
    "total_amt": "539.8",
    "customer_rank": "4",
    "total_state_revenue": "7057.47"
  },
  {
    "customer_unique_id": "dec89c5c369cecbc707083a24f1246f6",
    "customer_state": "RR",
    "total_amt": "403.10",
    "customer_rank": "5",
    "total_state_revenue": "7057.47"
  }
]
*/