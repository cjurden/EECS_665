%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int list_type;
%}

%option       noyywrap nounput yylineno
%x            COMMENT PARA PRE OL UL LI

%%

"<h1>"[^<]*"</h1>" {
    /**************************************************************************
     * Matched an HTML H1 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\section{%s}", yytext+4 );
}

"<h2>"[^<]*"</h2>" {
    /**************************************************************************
     * Matched an HTML H2 header so print it out as a LateX subsection title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsection{%s}", yytext+4 );
}

"<h3>"[^<]*"</h3>" {
    /**************************************************************************
     * Matched an HTML H3 header so print it out as a LateX subsubsection title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsubsection{%s}", yytext+4 );
}

"<!--" {
    /**************************************************************************
     * Matched an HTML comment so print it out as a LateX comment. The
     * beginning and ending tags are stripped off before the LateX comment
     * is emitted.
     *************************************************************************/
    printf( "%% " );
    BEGIN COMMENT;
}

[ \t\n\r]+ {
    /**************************************************************************
     * Matched some whitespace that is not inside of an HTML tag. We
     * just ignore the whitespace.
     *************************************************************************/
}

. {
    /**************************************************************************
     * Matched something that we did not expect to see. Issue an error and
     * exit the program with a failure message.
     *************************************************************************/
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}

<COMMENT>"-->" {
    /**************************************************************************
     * Matched an HTML end comment while parsing an HTML comment. Print out
     * a new line and resume normal parsing.
     *************************************************************************/
    printf( "\n" );
    BEGIN 0;
}

<COMMENT>[\n](\r)? {
    /**************************************************************************
     * Matched a newline and possible carriage return while parsing an HTML
     * comment. Print out a new line making sure to mark the next line as a
     * comment as well.
     *************************************************************************/
    printf( "\n%% " );
}

<COMMENT>[ \t] {
    /**************************************************************************
     * Matched some white space while parsing an HTML comment. Print out
     * the white space as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<COMMENT>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML comment. Print out
     * the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}

"<pre>" {
    /**************************************************************************
     * Matched an HTML pre so print it out as a latex verbatim. The
     * beginning and ending tags are stripped off before the LateX statement
     * is emitted.
     *************************************************************************/
     printf( "\\begin{verbatim}");
     printf( "\n" );
     BEGIN PRE;
}

[ \t\n\r]+ {
    /**************************************************************************
     * Matched some whitespace that is not inside of an HTML tag. We
     * just ignore the whitespace.
     *************************************************************************/
}

. {
    /**************************************************************************
     * Matched something that we did not expect to see. Issue an error and
     * exit the program with a failure message.
     *************************************************************************/
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}

<PRE>"</pre>" {
    /**************************************************************************
     * Matched an HTML end pre while parsing an HTML pre. Print out
     * a new line and resume normal parsing.
     *************************************************************************/
    printf( "\n" );
    printf( "\\end{verbatim}");
    printf( "\n" );
    BEGIN 0;
}

<PRE>[\n](\r)? {
    /**************************************************************************
     * Matched a newline and possible carriage return while parsing an HTML
     * pre. Print out a new line.
     *************************************************************************/
    printf( "\n" );
}

<PRE>[ \t] {
    /**************************************************************************
     * Matched some white space while parsing an HTML pre. Print out
     * the white space as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<PRE>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML pre. Print out
     * the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}

"<p>" {
  /**************************************************************************
   * Matched an HTML p so print it out as a latex paragraph. The
   * beginning and ending tags are stripped off before the LateX statement
   * is emitted.
   *************************************************************************/
   printf( "\n");
   BEGIN PARA;
}

<PARA>"</p>" {
  /**************************************************************************
   * Matched end of HTML p, add LaTex newline.
   *************************************************************************/
   printf( "\n" );
   BEGIN 0;
}

<PARA,LI>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML p. Print out
     * the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<PARA,LI>"<small>" {
  /**************************************************************************
   * Matched HTML small, add LaTex scriptsize.
   *************************************************************************/
   printf( "{\\scriptsize ");
}

<PARA,LI>"</small>" {
  /**************************************************************************
   * Matched end HTML small, close LaTex scriptsize bracket.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<big>" {
  /**************************************************************************
   * Matched HTML big, add LaTex large.
   *************************************************************************/
   printf( "{\\Large " );
}

<PARA,LI>"</big>" {
  /**************************************************************************
   * Matched end HTML small, end LaTex large.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<b>" {
  /**************************************************************************
   * Matched HTML bold, add LaTex textbf.
   *************************************************************************/
   printf( "\\textbf{" );
}

<PARA,LI>"</b>" {
  /**************************************************************************
   * Matched end HTML bold, end LaTex textbf.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<i>" {
  /**************************************************************************
   * Matched HTML i, add LaTex textit.
   *************************************************************************/
   printf("\\textit{");
}

<PARA,LI>"</i>" {
  /**************************************************************************
   * Matched end HTML i, end LaTex textit.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<strong>" {
  /**************************************************************************
   * Matched HTML strong, add LaTex textmd.
   *************************************************************************/
   printf("\\textmd{");
}

<PARA,LI>"</strong>" {
  /**************************************************************************
   * Matched end HTML small, end LaTex textmd.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<em>" {
  /**************************************************************************
   * Matched HTML em, add LaTex emph.
   *************************************************************************/
   printf("\\emph{");
}

<PARA,LI>"</em>" {
  /**************************************************************************
   * Matched end HTML em, end LaTex emph.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<sup>" {
  /**************************************************************************
   * Matched HTML superscript, add LaTex textsuperscript.
   *************************************************************************/
   printf("\\textsuperscript{");
}

<PARA,LI>"</sup>" {
  /**************************************************************************
   * Matched end HTML superscript, end LaTex textsuperscript.
   *************************************************************************/
   printf( "}" );
}

<PARA,LI>"<sub>" {
  /**************************************************************************
   * Matched HTML sub, add LaTex textsubscript.
   *************************************************************************/
   printf("\\textsubscript{");
}

<PARA,LI>"</sub>" {
  /**************************************************************************
   * Matched end HTML sub, end LaTex textsubscript.
   *************************************************************************/
   printf( "}" );
}

"<ol>" {
  /**************************************************************************
   * Matched HTML ol, begin LaTex enumerate.
   *************************************************************************/
   printf("\n");
   printf("\\begin{enumerate}");
}

"</ol>" {
  /**************************************************************************
   * Matched end HTML ol, end LaTex enumerate.
   *************************************************************************/
   printf("\\end{enumerate}");
   printf("\n");
   BEGIN 0;
}

"<ul>" {
  /**************************************************************************
   * Matched HTML ul, begin LaTex itemize.
   *************************************************************************/
   printf("\\begin{itemize}");
}

"</ul>" {
  /**************************************************************************
   * Matched end HTML ul, end LaTex itemize.
   *************************************************************************/
   printf("\\end{itemize}");
   printf("\n");
   BEGIN 0;
}

"<li>" {
  /**************************************************************************
   * Matched an HTML p so print it out as a latex paragraph. The
   * beginning and ending tags are stripped off before the LateX statement
   * is emitted.
   *************************************************************************/
   printf( "\\item ");
   BEGIN LI;
}

<LI>"</li>" {
  /**************************************************************************
   * Matched end of HTML p, add LaTex newline.
   *************************************************************************/
   printf( "\n" );
   BEGIN 0;
}



%%

/**************************************************************************
 * The main function for the HTML to LateX converter. Here we do three
 * things:
 *  1. Print out the LateX document header.
 *  2. Invoke the lexer to print out the LateX document
 *  3. Print out the LateX footer.
 *************************************************************************/
int main( int argc, const char *argv[] ) {
    printf( "\\documentclass[12pt]{article}\n" );
    printf( "\\usepackage{fixltx2e}\n" );
    printf( "\n" );
    printf( "\\setlength{\\parindent}{0.0in}\n" );
    printf( "\\setlength{\\parskip}{0.125in}\n" );
    printf( "\n\n" );
    printf( "\\begin{document}\n" );
    yylex();
    printf( "\\end{document}\n" );
    return 0;
}
