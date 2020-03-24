/*
* @Author: UnsignedByte
* @Date:   10:55:29, 19-Mar-2020
* @Last Modified by:   UnsignedByte
* @Last Modified time: 12:19:48, 24-Mar-2020
*/

import java.io.*;
import java.util.*;

public class parsetext {
	public static final Character[] separators = {'!','.','?'}; //Characters denoting the end of a line
	public static final String[] specialWords = {"mr.","ms.","mrs."}; //Words breaking this rule
	public static final Character[] keptChars = {'\''}; //Characters to keep in words that aren't letters
	public static final Character[] inlinepunc = {';',':',','}; //Punctuation that doesnt separate lines

	public static boolean contains(Object[] a, Object b){
		for(Object c : a){
			if (b.equals(c)) return true;
		}
		return false;
	}

    public static void main(String[] args) throws FileNotFoundException, IOException{
        InputManager input;
        PrintWriter output;
    	File source = new File("Plaintext-Data/Sources");
        String fileOut = "Plaintext-Data/compiledraw.txt";
        output = new PrintWriter(new BufferedWriter(new FileWriter(fileOut)));

    	for (File fileEntry : source.listFiles(new FilenameFilter() {
			        @Override
			        public boolean accept(File dir, String name) {
			            return !name.equals(".DS_Store");
			        }
			    })
    		) {
        	input = new InputManager(new BufferedReader(
        		new InputStreamReader(new FileInputStream("Plaintext-Data/Sources/"+fileEntry.getName()), "UTF-8")));


        	StringBuilder lines = new StringBuilder();
        	while(input.hasNext()){
        		String s = input.next().toLowerCase();
        		if (contains(specialWords, s)){
        			lines.append(s);
        			lines.append(' ');
        		}else{
        			boolean EOL = false;
	        		for(int i = 0; i < s.length(); i++){
	        			char c = s.charAt(i);
        				if (contains(separators, c)){
	        				lines.append(new char[] {' ', c, '\n'});
	        				EOL = true;
        				}else if (contains(inlinepunc, c)){
        					lines.append(new char[] {' ', c});
	        			}else if (('a' <= c && c <= 'z') || ('0' <= c && c <= '9') || contains(keptChars, c)){
		        			lines.append(Character.toLowerCase(c));
	        			}
	        		}
	        		if (!EOL) lines.append(' ');
        		}
        	}
        	// System.out.println(lcount);
        	output.write(lines.toString());
	    }



        output.flush();
    }
    public static class InputManager{
        public Queue<String> tokens = new LinkedList<>();
        public BufferedReader input;

        public InputManager(BufferedReader input){
            this.input = input;
        }

        private void updateLine() throws IOException{
            while (tokens.isEmpty()){
                String line = input.readLine();
                if (line == null){
                    tokens = null;
                    return;
                }
                tokens = new LinkedList(Arrays.asList(line.split("[\\s\\u2014\\u2013]+")));
            }
        }

        public boolean hasNext() throws IOException{
            this.updateLine();
            return tokens != null;
        }

        public String next() throws IOException{ //get next string
            this.updateLine();
            return tokens.poll();
        }

        public int nextInt() throws IOException{ //get next int
            this.updateLine();
            return Integer.parseInt(tokens.poll());
        }

        public char nextChar() throws IOException{ //get next int
            this.updateLine();
            return tokens.poll().charAt(0);
        }

        public String nextLine() throws IOException{ //get all remaining tokens in line
            this.updateLine();
            StringBuilder sb = new StringBuilder();
            sb.append(tokens.poll());
            while(!tokens.isEmpty()){
                sb.append(" ").append(tokens.poll());
            }
            return sb.toString();
        }
    }
}
