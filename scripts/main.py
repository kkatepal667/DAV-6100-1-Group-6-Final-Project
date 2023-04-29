from bs4 import BeautifulSoup
import csv
import requests


def scrape_data(soup):
    table = soup.find("table")

    for row in table.findAll('tr')[1:]:
        col = row.find_all('td')
        date = col[1].string
        state = col[2].string
        city = col[3].string
        killed = col[5].string
        injured = col[6].string

        writer.writerow({str(headings[0]): str(date), str(headings[1]): str(state), str(headings[2]): str(city),
                         str(headings[3]): str(killed), str(headings[4]): str(injured)})


file_path = 'web-scrapped-dataset.csv'

csv1 = open(file_path, mode='w', newline='')
headings = ['Date', 'State', 'City_country', 'n_killed', 'n_injured']
writer = csv.DictWriter(csv1, fieldnames=headings)
writer.writeheader()

years = [2014, 2015, 'year=2016', 'year=2017', 'year=2018', 'year=2019']

for i in range(len(years)):

    base_url = 'https://www.gunviolencearchive.org/reports'
    next_url = '/mass-shootings/' + str(years[i]) + '?sort=asc&order=Incident%20Date'

    if i >= 2:
        next_url = '/mass-shooting?' + str(years[i])

    while next_url:
        agent = {"User-Agent": "Mozilla/5.0"}
        next_page = requests.get(base_url + next_url, headers=agent)
        print(base_url + next_url)
        base_url = 'https://www.gunviolencearchive.org'

        c = next_page.content
        soup = BeautifulSoup(c, 'lxml')
        scrape_data(soup)
        next_url = soup.find('a', {'title': 'Go to next page'})
        if next_url:
            next_url = next_url.get('href')
            print(next_url)
csv1.close()
