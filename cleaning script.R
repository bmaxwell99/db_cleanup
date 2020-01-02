source('input script.R')

#removes the approximately 250 blank entries
data <-
  data %>% 
  filter(!(state == '' & city == '' & abstract == '' & text == ''))

alpha_id <-
  data %>% 
  #entries that are strictly numbers will get reduced to blank string
  mutate(id = str_remove_all(id, '\\d')) %>% 
  #removes the blank strings(valid ID values)
  filter(id != '') %>% 
  #removes the 19th entry, which is an otherwise valid row of data
  slice(1:18) %>% 
  #retains only the ID column for later membership test
  select(id)

#Removes the 18 "nonsense" rows
data <-
  data %>% 
  #memberhsip test: removes any rows that share a ID value alpha_id
  filter(!(is.element(id, alpha_id$id)))

remove(alpha_id)

#Suggest sending the below data to Omar, along with the list of tag options, 
#and then manually adding the tags Omar suggests. 
#missing_tags <-
#  data %>% 
#  filter(tags  == '')

city_state <-
  #inputs the downloaded states and city data set
  read.csv('uscities.csv', stringsAsFactors = F) %>% 
  select(city_ascii, state_name) %>% #be sure to use city_ascii not of city
  #converts to lower case to ensure compatability 
  mutate(city_ascii = tolower(city_ascii)) %>% 
  mutate(state_name = tolower(state_name))

data <-
  data %>% 
  #whitespace and case removal for State column
  mutate(state = trimws(state)) %>% 
  mutate(state = tolower(state))

#creates a summary of all State values that do not conform.
errors <-
  data %>% 
  filter(!(is.element(state, city_state$state_name ))) %>% 
  group_by(state) %>% 
  summarise(count = n()) %>% 
  arrange(count)

#creates a reference value for the 'new yorkâ ' value which did not seem to respond to copy and paste
n_y <-
  data %>% 
  filter(!(is.element(state, city_state$state_name ))) %>%
  mutate(state_short = str_sub(state, 1, 8)) %>% 
  filter(state_short == 'new york') %>% 
  group_by(state) %>% 
  summarise(n())

#replaces erroneous state values with correct ones
data <-
  data %>% 
  mutate(state = replace(state, state == 'conneticut', 'connecticut')) %>% 
  mutate(state = replace(state, state == n_y$state, 'new york')) %>% 
  mutate(state = replace(state, state == 'district of colombia', 'washington d.c.')) %>% 
  mutate(state = replace(state, is.element(state, c('massachusettes', 'massachussettes')), 'massachusetts')) %>% 
  mutate(state = replace(state, is.element(state, c('orlando', 'floirda', 'floriad')), 'florida')) %>% 
  mutate(state = replace(state, is.element(state, c('viriginia', 'va')), 'virginia')) %>% 
  mutate(state = replace(state, state == 'vermotn', 'vermont')) %>% 
  mutate(state = replace(state, is.element(state, c('new jerser', 'new jersery', 'new jersy')), 'new jersey'))
  
  


