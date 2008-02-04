#!/usr/bin/env ruby
# Copyright 2008 Wincent Colaiuta
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require File.join(File.dirname(__FILE__), '..', 'ext', 'wikitext')
require 'benchmark'

# 91 characters, 91 bytes
short_slab_of_ASCII_text  = '* Lorem [[ipsum|hello]] dolor sit amet, `consectetuer` http://example.com/ adipiscing elit.'

# 91 characters, 122 bytes
short_slab_of_UTF8_text   = '* Lór€m [[ïpsûm|h€llö]] dólór sït àm€t, `cóñs€ct€tû€r` http://example.com/ àdïpïscïñg €lït.'

# 1415 characters, 1415 bytes
longer_slab_of_ASCII_text = <<SLAB
paragraph
second line

new paragraph

= a heading =

> a blockquote
> second line of blockquote
>
> new paragraph within blockquote

== another heading ==

paragraph within ''multiple '''styles''''' and <tt>tt span</tt>

similar, but with '''styles in ''different'' order'''

again, a '''different ''order'''''

* list item 1
** nested list item 1
** nested list item 2
** nested list item 3
* list item 2

 // this is a code block
 notice how it can contain ''markup''
 which would '''otherwise''' have <tt>special</tt> meaning
 although explicit entities &copy; are passed through unchanged

a normal paragraph again

This is where we show a link to an article on [[GCC]].
Related to that, [[GCC|a link]] to the same
article but with custom link text.

External links [http://example.com work too].
As well as autolinks as seen http://example.com/
here.

Look at how we handle bad syntax. [[This is an unterminated
link. And [http://example.com/ is another.

# this is an ordered list
# which continues
## and has another ordered list
## nested inside it
# and then falls back
#* and then nests another list
#* this time an unordered one
#** itself containing a nested list
#** which continues
#**# and finally nests yet another ordered list
#**# which continues
#* drops back quite a way
# and finally all the way
#****** and finishes with an invalid item

=== heading with missing closing tag
* list
# new list
SLAB

# 1415 characters, 2061 bytes
longer_slab_of_UTF8_text  = <<SLAB
pärägräph
∫€cöñd lîñ€

ñ€w pärägräph

= ä h€ädîñg =

> ä blöckquöt€
> ∫€cöñd lîñ€ öf blöckquöt€
>
> ñ€w pärägräph wîthîñ blöckquöt€

== äñöth€r h€ädîñg ==

pärägräph wîthîñ ''multîpl€ '''∫tyl€∫''''' äñd <tt>tt ∫päñ</tt>

∫îmîlär, but wîth '''∫tyl€∫ îñ ''dîff€r€ñt'' örd€r'''

ägäîñ, ä '''dîff€r€ñt ''örd€r'''''

* lî∫t ît€m 1
** ñ€∫t€d lî∫t ît€m 1
** ñ€∫t€d lî∫t ît€m 2
** ñ€∫t€d lî∫t ît€m 3
* lî∫t ît€m 2

 // thî∫ î∫ ä cöd€ blöck
 ñötîc€ höw ît cäñ cöñtäîñ ''märkup''
 whîch wöuld '''öth€rwî∫€''' häv€ <tt>∫p€cîäl</tt> m€äñîñg
 älthöugh €xplîcît €ñtîtî€∫ &cöpy; är€ pä∫∫€d thröugh uñchäñg€d

ä ñörmäl pärägräph ägäîñ

Thî∫ î∫ wh€r€ w€ ∫höw ä lîñk tö äñ ärtîcl€ öñ [[GCC]].
R€lät€d tö thät, [[GCC|ä lîñk]] tö th€ ∫äm€
ärtîcl€ but wîth cu∫töm lîñk t€xt.

Ext€rñäl lîñk∫ [http://example.com wörk töö].
A∫ w€ll ä∫ äutölîñk∫ ä∫ ∫€€ñ http://example.com/
her€.

Löök ät höw w€ häñdl€ bäd ∫yñtäx. [[Thî∫ î∫ äñ uñt€rmîñät€d
lîñk. Añd [http://example.com/ î∫ äñöth€r.

# thî∫ î∫ äñ örd€r€d lî∫t
# whîch cöñtîñu€∫
## äñd hä∫ äñöth€r örd€r€d lî∫t
## ñ€∫t€d îñ∫îd€ ît
# äñd th€ñ fäll∫ bäck
#* äñd th€ñ ñ€∫t∫ äñöth€r lî∫t
#* thî∫ tîm€ äñ uñörd€r€d öñ€
#** ît∫€lf cöñtäîñîñg ä ñ€∫t€d lî∫t
#** whîch cöñtîñu€∫
#**# äñd fîñälly ñ€∫t∫ y€t äñöth€r örd€r€d lî∫t
#**# whîch cöñtîñu€∫
#* dröp∫ bäck quît€ ä wäy
# äñd fîñälly äll th€ wäy
#****** äñd fîñî∫h€∫ wîth äñ îñvälîd ît€m

=== h€ädîñg wîth mî∫∫îñg clö∫îñg täg
* lî∫t
# ñ€w lî∫t
SLAB

def parse job, description, parser, input
  job.report(description) do
    100_000.times { parser.parse input }
  end
end

parser = Wikitext::Parser.new
Benchmark.bmbm do |job|
  parse job, 'short slab of ASCII text', parser, short_slab_of_ASCII_text
  parse job, 'short slab of UTF-8 text', parser, short_slab_of_UTF8_text
  parse job, 'longer slab of ASCII text', parser, longer_slab_of_ASCII_text
  parse job, 'longer slab of UTF-8 text', parser, longer_slab_of_UTF8_text
end
