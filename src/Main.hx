import sml.Lexer;

class Main {
	static function main() {
		trace(@:privateAccess Lexer.scanFile("src/example.sml"));
	}
}
