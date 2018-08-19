// this file is a scratch for c++ coding


template<class T>
class MyClass {

public:
    MyClass(T t) {
    }

}


    class Solution {
    public:
        string result;
        class Trie {
        private:
            vector<Trie*> children(26);
            bool isword;
            char letter;
        public:
            Trie(char letter) {
                letter = letter;
            }

            void add(string word){
                char letter = word[0];
                int index = l - 'a';
                children[index] = new Trie(letter);
                if (word.size() == 1) {
                    isword = true;
                    return;
                }
                children[index] -> add(word.substr(1));
            }


            void dfs(const string& word) {
                if (isword){
                    if(word.size() > result.size()) {
                        result = word;
                    }
                }

                for (int i = 0; i < children.size(); i ++ ) {
                    if (children[i] != NULL) {
                        char curr = children[i] -> letter; 
                        children[i] -> dfs(word + curr );
                    }
                }
            }

        };

        string longestWord(vector<string>& words) {
            Trie* root = new Trie('');
            for (auto word : words){
                root -> add(word);
            }
            root -> dfs("");
            return result; 

        }
    };
