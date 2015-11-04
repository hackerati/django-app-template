from django.utils import timezone
from django.test import TestCase

from sample_app.models import PageLoad

# Create your tests here.


class PageLoadTestCase(TestCase):
    number_of_dummy_loads = 2

    @classmethod
    def setUpTestData(cls):
        for i in xrange(cls.number_of_dummy_loads):
            page_load = PageLoad()
            page_load.save()

    def test_1(self):
        number_of_rows = len([model for model in PageLoad.objects.all()])
        self.assertEqual(number_of_rows, self.number_of_dummy_loads)

    def test_2(self):
        date_regex = r'\d{4}/\d{2}/\d{2} at \d{2}:\d{2}:\d{2}'
        date_strings = [page_load.format_datetime() 
                for page_load in PageLoad.objects.all()]
        for date_string in date_strings:
            self.assertRegexpMatches(date_string, date_regex)

    def test_3(self):
        now = timezone.now()
        datetimes = [page_load.datetime_stamp 
                        for page_load in PageLoad.objects.all()]
        for datetime in datetimes:
            self.assertTrue(now > datetime)
            self.assertLess( (now - datetime).seconds, 60)
        
