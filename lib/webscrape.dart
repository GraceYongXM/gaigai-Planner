import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'services/webscrape_service.dart';

final _client = WebscrapeService();
List<int> invalidResults = [10];

void extractData() async {
  if (!(await _client.dataExists())) {
    String websiteStart = 'https://thrillophilia.com';

    int index = 1;

    for (int i = 1; i <= 10; i++) {
      //looping through different result pages of main page
      String website =
          'https://www.thrillophilia.com/countries/singapore/things-to-do?page=$i';

      final response = await http.Client().get(Uri.parse(website));
      //Status Code 200 means response has been received successfully

      if (response.statusCode == 200) {
        //Getting the html document from the response
        var document = parser.parse(response.body);
        String className = 'results';

        for (int j = 0; j <= 20; j++) {
          print(index);
          index++;

          //looping through 21 results on each page
          if (!invalidResults.contains(index)) {
            try {
              var link = document
                  .getElementsByClassName(className)[0]
                  .children[j]
                  .attributes['data-href'];
              //scraping the website link for result j

              final result =
                  await http.Client().get(Uri.parse(websiteStart + link!));

              var product = parser.parse(result.body);

              const titleClass = 'base-block-head';
              const locationClass = 'product-overview__details';
              const costClass = 'pricing-wrap__current-price-wrap';
              const descriptionClass = 'product-overview__details';

              String location = product
                  .getElementsByClassName(locationClass)[0]
                  .getElementsByTagName('div')[0]
                  .children[0]
                  .text;
              List<String> splitLocation = location.split(' ');
              if (!splitLocation.contains('Location:') &&
                  !splitLocation.contains('Location-')) {
                location = product
                    .getElementsByClassName(locationClass)[0]
                    .getElementsByTagName('div')[0]
                    .children[3]
                    .text;
                splitLocation = location.split(' ');
              }
              int indexOfLocation = 0;
              for (String splitPart in splitLocation) {
                if (splitPart != 'Location:' && splitPart != 'Location-') {
                  indexOfLocation++;
                } else {
                  break;
                }
              }
              location = splitLocation
                  .getRange(indexOfLocation + 1, splitLocation.length)
                  .join(' ');

              const adultRemove = 9;
              const seniorRemove = 11;
              const currencyRate = 56.18;
              String cost =
                  product.getElementsByClassName(costClass)[0].children[0].text;
              if (cost.endsWith('Adult')) {
                cost = cost.substring(0, cost.length - adultRemove);
              } else {
                cost = cost.substring(0, cost.length - seniorRemove);
              }
              cost = (cost.split(' '))[1];
              cost = cost.replaceAll(',', '');
              cost = (double.parse(cost) / currencyRate).toStringAsFixed(2);
              double finalCost = double.parse(cost);

              const lettersToRemove = 11;
              String title = product.getElementsByClassName(titleClass)[1].text;
              title = title.substring(0, title.length - lettersToRemove);

              String description = product
                  .getElementsByClassName(descriptionClass)[0]
                  .getElementsByTagName('div')[0]
                  .children[4]
                  .text;
              if (description.substring(0, 5) == 'About') {
                description = product
                    .getElementsByClassName(descriptionClass)[0]
                    .getElementsByTagName('div')[0]
                    .children[5]
                    .text;
              }

              _client.insertActivity(
                title: title,
                location: location,
                cost: finalCost,
                description: description,
              );
            } catch (e) {
              print('error here ${e.toString()}');
            }
          }
        }
      }
    }
  }
}
