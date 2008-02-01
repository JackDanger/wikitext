// Copyright 2008 Wincent Colaiuta
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include <ruby/ruby.h>
#include <stdint.h>

// error raised when scanning fails
extern VALUE eWikitextError;

typedef struct
{
    char        *start;
    char        *stop;
    size_t      line_start;
    size_t      line_stop;
    size_t      column_start;
    size_t      column_stop;
    uint32_t    code_point;
    int         type;
} token_t;

enum token_types {
    NO_TOKEN,
    P,              // imaginary token (never explicitly marked up)
    LI,             // imaginary token (never explicitly marked up)
    PRE,
    NO_WIKI_START,
    NO_WIKI_END,
    BLOCKQUOTE,
    STRONG_EM,
    STRONG,
    EM,
    TT_START,
    TT_END,
    TT,
    OL,
    UL,
    H6_START,
    H5_START,
    H4_START,
    H3_START,
    H2_START,
    H1_START,
    H6_END,
    H5_END,
    H4_END,
    H3_END,
    H2_END,
    H1_END,
    URI,
    LINK_START,
    LINK_END,
    EXT_LINK_START,
    EXT_LINK_END,
    SEPARATOR,
    SPACE,
    QUOT_ENTITY,
    AMP_ENTITY,
    NAMED_ENTITY,
    HEX_ENTITY,
    DECIMAL_ENTITY,
    QUOT,
    AMP,
    LESS,
    GREATER,
    CRLF,
    PRINTABLE,
    DEFAULT,
    END_OF_FILE
};
