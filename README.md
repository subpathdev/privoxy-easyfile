Privoxy-Easyfile
=============================

This Projekt download a the easyfile from the websites https://easylist-downloads.adblockplus.org/easylistgermany.txt and http://adblockplus.mozdev.org/easylist/easylist.txt

Describtion
----------------------------
When I started to write this Programm, the problem was that I didn't find anything about a few symbols. These symbols are used in easylist. So I started to write a minimal documentation for this:

symbol | significance
---|---
&asdf | everything, which url contains asdf, are blocked


Using
-----------------------------
you have to change your configuration file and insert 2 new actionfiles after user.actionfile.
The actionfiles named:
- easy.actionfile
- germany.actionfile
- easy.filter
- germany.filter

Similar Software
-----------------------------
privoxy-blackliste: https://github.com/andrwe/privoxy-blocklist.git
privoxy-adblock: https://github.com/skroll/privoxy-adblock.git
