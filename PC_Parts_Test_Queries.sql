# This call will show adding a gpu to a build that does not already have an instance of said gpu
CALL add_gpu(6, 'Small Form Factor Build', 'Sapphire', 'Vapor-X', 'AMD Radeon 280X');

# This call will show adding a gpu to a build that already has an instance of said gpu
# Satisfies Update
CALL add_gpu(1, 'Cole\'s Build', 'MSI', 'ARMOR', 'NVIDIA GeForce GTX 1080 Ti');

# This call will show removing a gpu from a build that has more than one instance of said gpu
# Satisfies Update
CALL remove_gpu(1, 'Server Build', 'XFX', 'Radeon VII', 'Radeon VII');

# This call will show removing a gpu from a build that only has one instance of said gpu, the tuple will be removed from the table
# Satisfies Delete
CALL remove_gpu(3, 'The Bibblerson', 'EVGA', 'FTW3 ULTRA GAMING', 'NVIDIA GeForce RTX 2080 Ti');

# This function will return the aggregated price of all the items in the specified build
# Satisfies subquery
# Satisfies query joining 3 or more tables
SELECT `build_price`(1, 'Server Build') AS 'Price';

# This view will sort all the gpus by most bought and display the quantity per each unique card
SELECT * FROM most_bought_gpus;

# THis view will display the single most bought chip and show how many have been purchased
SELECT * FROM most_bought_chip;

# This view will display the single most bought model and show how many have been purchased
SELECT * FROM most_bought_model;

# This view will display the single most bought brand and show how many units they have shipped
SELECT * FROM most_bought_brand;

# This view will show the name of the most expensive build as well as its total price
SELECT * FROM most_expensive_build;

# Query displays cases that have the mini form factor and also support both Mirco ATX and Mini ITX motherboard form factors
# Satisfies Union
SELECT case_.brand AS Manufacturer, case_.model AS Model FROM case_ WHERE case_.form_factor = 'Mini'
UNION
SELECT case_motherboard_support_.case_brand AS Manufacturer, case_motherboard_support_.case_name AS Model FROM case_motherboard_support_ WHERE motherboard_form_factor = 'Micro-ATX' AND motherboard_form_factor = 'Mini-ITX';

# Query displays all of the motherboards currently in use in a build
# Satisfies Distinct
SELECT DISTINCT motherboard_brand AS 'Brand', motherboard_name AS 'Model' FROM build_;

# Query diplays all of the ram kits which are not supported by a current motherboard
# Satisfies WHERE EXISTS or WHERE NOT EXISTS
SELECT DISTINCT frequency AS `Speed` FROM ram_ WHERE NOT EXISTS (SELECT * FROM motherboard_ram_speeds_ WHERE frequency = speed);

# Query displays the motherboards that support ram speeds in excess of 4000MHz
# Satisfies GROUP BY and HAVING
SELECT motherboard_brand, motherboard_name FROM motherboard_ram_speeds_ GROUP BY motherboard_brand, motherboard_name HAVING MAX(speed) >= 4000;