% Meal planning

% meats
meat(beef).
meat(hotdog).
meat(sausage).
meat(spam).
meat(pork).
meat(chicken).
meat(quail).
meat(haggis).
meat(veal).
meat(burger).
meat(venison).
meat(boar).
meat(lamb).
meat(rabbit).
meat(steak).

%breakfastMeats
brmeat(egg).
brmeat(bacon).
brmeat(sausage_links).

% fish
fish(salmon).
fish(talapia).
fish(cod).
fish(halibut).
fish(crawfish).
fish(lobster).
fish(crab).
fish(shrimp).
fish(clams).
fish(oysters).

% veggies
veg(carrot).
veg(cabbage).
veg(lettuce).
veg(potato).
veg(celery).
veg(radish).
veg(squash).
veg(pumpkin).
veg(gourd).
veg(zucchini).
veg(cucumber).
veg(broccoli).
veg(cauliflower).
veg(brussel_sprouts).
veg(asparaugus).

% fruit
fruit(apple).
fruit(banana).
fruit(strawberry).
fruit(kiwi).
fruit(pineapple).
fruit(blueberry).
fruit(raspberry).
fruit(blackberry).
fruit(huckleberry).
fruit(orange).

% drupe
drupe(coconut).

% beans
beans(lupini_beans).
beans(fava_beans).
beans(lima_beans).
beans(garbanzo_beans).
beans(black_beans).
beans(refried_beans).
beans(pinto_beans).
beans(kidney_beans).

% chips
chips(fritos).
chips(pringles).
chips(lays).
chips(tortilla_chips).
chips(pita_chips).

% saltysnack
munchies(popcorn).
munchies(pretzels).
munchies(pickles).
munchies(fries).

% sweets
sweet(cake).
sweet(cookies).
sweet(chocolate).
sweet(pie).
sweet(tiramisu).
sweet(baklava).
sweet(tres_leches).
sweet(brownies).
sweet(fudge).
sweet(ice_cream).
sweet(gelato).

% soda
soda(pepsi).
soda(coke).
soda(diet_pepsi).
soda(diet_coke).
soda(mountain_dew).
soda(mountain_dew_code_red).
soda(mountain_dew_voltage).
soda(mountain_dew_whiteout).
soda(mountain_dew_livewire).
soda(mountain_dew_black_label).
soda(mountain_dew_baja_blast).
soda(mountain_dew_crystal).
soda(dr_pepper).
soda(diet_dr_pepper).
soda(rootbeer).

% beer
alcohol(ipa).
alcohol(stout).
alcohol(porter).
alcohol(pilsner).
alcohol(wheat).
alcohol(gluten_free).
alcohol(sour).
alcohol(lager).
alcohol(pale_ale).
alcohol(golden_ale).
alcohol(cream_ale).
alcohol(blonde_ale).
alcohol(nitro).

% wine
alcohol(white_wine).
alcohol(red_wine).

% juice
juice(apple_juice).
juice(pomegranate_juice).
juice(grape_juice).
juice(orange_juice).
juice(cranberry_juice).
juice(prune_juice).

% water
water(tap_water).
water(sparkling_water).


% Rule for drinks
drink(D):-
  soda(D); alcohol(D); juice(D); water(D).

% Rule for breakfast drinks
bfdrink(D):-
  juice(D); water(D).

% Rule for lunch drinks
ldrink(D):-
  alcohol(D); soda(D); water(D).

% Rule for snacks
snack(S):-
  chips(S); munchies(S); fruit(S).

% Rule for sides
side(S):-
  beans(S); chips(S); fruit(S); munchies(S).

% Rule for desert
desert(D):-
  sweet(D); fruit(D).

% Rule for protien
protien(P):-
  meat(P); fish(P).

% Rule for breakfast
breakfast(P, VorF, D):-
  (brmeat(P), (fruit(VorF); veg(VorF)), bfdrink(D)).

% Rule for lunch
lunch(P, VorF, D):-
  (protien(P), (veg(VorF); side(VorF)), ldrink(D)).

% Rule for dinner
dinner(P, V1, Side, D, S):-
  (protien(P), veg(V1), side(Side), drink(D), desert(S)).
