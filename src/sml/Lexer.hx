package sml;

import sys.io.File;

using StringTools;

@:allow(sml.SML)
@:access(sml.SML)
class Lexer {
	static function scanFile(url:String):Scope {
		return scan(File.getContent(url));
	}

	static function scan(code:String):Scope {
		return tokenize(code.split("\n"));
	}

	static function tokenize(lines:Array<String>):Scope {
		var scope:Scope = {children: [], statements: []};
		var statement:Array<Token> = [];

		for (l in 0...lines.length) {
			var line = lines[l];
			// remove comments
			var cind = line.indexOf("//");
			line = line.substring(0, cind == -1 ? line.length : cind);
			
			line = line.trim();
			if (line == "")
				continue;

			line += "\n";

			var i = 0;
			var c;
			while (i < line.length) {
				var token:Token = {
					type: null,
					value: null,
					loc: {
						line: l + 1,
						col: i + 1
					}
				};
				c = line.charAt(i);
				switch (c) {
					case ".":
						token.type = Dot;
						token.value = c;
					case ",":
						token.type = Comma;
						token.value = c;
					case ":":
						token.type = Colon;
						token.value = c;
					case ";":
						token.type = Semicolon;
						token.value = c;
					case "+":
						token.type = Plus;
						token.value = c;
					case "-":
						token.type = Minus;
						token.value = c;
					case "*":
						token.type = Asterisk;
						token.value = c;
					case "/":
						token.type = Slash;
						token.value = c;
					case "%":
						token.type = Mod;
						token.value = c;
					case "<":
						token.type = Lower;
						token.value = c;
					case ">":
						token.type = Greater;
						token.value = c;
					case "=":
						token.type = Equals;
						token.value = c;
					case "{":
						token.type = OpenBrace;
						token.value = c;
					case "}":
						token.type = CloseBrace;
						token.value = c;
					case "(":
						token.type = OpenParen;
						token.value = c;
					case ")":
						token.type = CloseParen;
						token.value = c;
					case "\n":
						token.type = LineBreak;
						token.value = c;
					case quotes = "\"" | "\'":
						var string = "";
						while (i < line.length) {
							i++;
							c = line.charAt(i);
							if (c != quotes)
								string += c;
							else
								break;
						}
						token.type = StringLiteral;
						token.value = string;
					default:
						if (isLiteral(c)) {
							var identifier = c;
							while (i < line.length - 1) {
								c = line.charAt(i + 1);
								if (isLiteral(c) || isDigit(c))
									identifier += c;
								else
									break;
								i++;
							}
							token.type = isKeyWord(identifier) ? KeyWord : Identifier;
							token.value = identifier;
						} else if (isDigit(c)) {
							var number = c;
							var dot = false;
							i++;
							while (i < line.length && !line.isSpace(i)) {
								c = line.charAt(i);
								if (isDigit(c))
									number += c;
								else if (c == "." && !dot) {
									number += c;
									dot = true;
								} else
									break;
								i++;
							}
							token.type = NumberLiteral;
							token.value = number;
						}
				}

				if (token.type != null) {
					switch (token.type) {
						case OpenBrace:
							var s = {parent: scope, children: [], statements: []};
							scope.children.push(s);
							scope = s;
						case CloseBrace:
							scope = scope.parent;
						case LineBreak:
							scope.statements.push(statement);
							statement = [];
						case _:
							statement.push(token);
					}
				}
				i++;
			}
		}
		return scope;
	}

	static function isKeyWord(s:String):Bool {
		return SML.KEYWORDS.contains(s);
	}

	static function isLiteral(c:String):Bool {
		return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z");
	}

	static function isDigit(c:String):Bool {
		return (c >= "0" && c <= "9");
	}
}

typedef Token = {
	type:TokenType,
	value:String,
	loc:{
		line:Int, col:Int
	}
}

enum TokenType {
	Dot; // .
	Comma; // ,
	Colon; // :
	Semicolon; // ;
	Plus; // +
	Minus; // -
	Asterisk; // *
	Slash; // /
	Mod; // %
	Lower; // <
	Greater; // >
	Equals; // =
	OpenBrace; // {
	CloseBrace; // }
	OpenParen; // (
	CloseParen; // )
	LineBreak; // \n
	KeyWord;
	Identifier;
	StringLiteral;
	NumberLiteral;
}

typedef Scope = {
	var ?parent:Scope;
	var children:Array<Scope>;
	var statements:Array<Array<Token>>;
}
