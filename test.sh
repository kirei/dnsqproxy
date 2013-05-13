#!/bin/sh

perl qtest.pl | perl qproxy.pl | perl qparse.pl
