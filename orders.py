from robot.libraries.BuiltIn import BuiltIn
from JsonValidator import JsonValidator


class Order:
    builtin_lib = BuiltIn()
    js = JsonValidator()

    def get_postgresql_lib(self):
        return self.builtin_lib.get_library_instance("DB")

    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    def get_orders_from_rest(self, alias, params, expected_status):
        result = self.get_requests_lib().get_on_session(alias=alias, url='/orders?', params=params,
                                                        expected_status=expected_status)

        order_id = self.js.get_elements(result.json(), '$..orderid')
        order_date = self.js.get_elements(result.json(), '$..orderdate')

        return order_id, order_date

    def get_orders_by_date_and_total_amount(self, orderdate, totalamount):
        self.builtin_lib.log('Get orders with amount>300 and orderdate=2004-01-01')
        sql = """SELECT orderid, orderdate, totalamount
                 FROM "orders"
                 WHERE totalamount>%(totalamount)s
                 AND orderdate=%(orderdate)s"""
        params = {"orderdate": orderdate, "totalamount": totalamount, }

        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)

    def get_orders_and_dates(self, data: list):
        order_ids = []
        order_dates = []
        for i in data:
            order_ids.append(int(i['orderid']))
            order_dates.append(str(i['orderdate']))
        return order_ids, order_dates
