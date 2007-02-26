# Add ".." to module include path
import sys,os; sys.path.append(os.path.dirname(sys.argv[0]) + os.sep + os.pardir)

import unittest

import dir2entities

class MakeRelativePathTestCase(unittest.TestCase):
    def __init__(self, methodName='runTest'):
        unittest.TestCase.__init__(self,methodName)
    
    def do_test(self, dict):
        self.failUnlessEqual(
            dir2entities.make_relative_path(dict["from_dir"], dict["to_dir"]),
            dict["expectation"],
            )
    def test0(self):
        self.do_test({
            "from_dir": "/usr/",
            "to_dir": "/usr/share/bob",
            "expectation": "share/bob",
            })
    def test1(self):
        self.do_test({
            "from_dir": "/home/bruce",
            "to_dir": "/home/bob",
            "expectation": "../bob",
            })
    def test2(self):
        self.do_test({
            "from_dir": "/usr/lib/bob",
            "to_dir": "/etc/asdf",
            "expectation": "../../../etc/asdf",
            })
    def test3(self):
        self.do_test({
            "from_dir": "/usr/lib/bob",
            "to_dir": "/",
            "expectation": "../../..",
            })
    def test4(self):
        self.do_test({
            "from_dir": "/",
            "to_dir": "/usr/lib/bob",
            "expectation": "usr/lib/bob",
            })

if __name__ == "__main__":
    unittest.main()
