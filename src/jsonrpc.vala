/* jsonrpc.vala
 *
 * Copyright (C) 2011  David Edwards
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 * 	David Edwards <david@more.fool.me.uk>
 */

using Json;
using Soup;

public errordomain RPCError {
	EMPTY_RESPONSE,
    FAILED_TO_PARSE_RESPONSE
}

public class Squeezebox.JsonRPC : GLib.Object {
	
	protected string host = "localhost";
	protected string port = "9000";
	private string path = "jsonrpc.js";
	
	protected JsonRPC() {
	}
	
	protected GLib.Variant call(string player_id,GLib.Variant input) throws RPCError {

		var uri = "http://" + host + ":" + port + "/" + path;
		
		var session = new Soup.SessionSync();
		var message = new Soup.Message("POST", uri);
		
		// Wrap the input parameters to make them into a Squeezebox JsonRPC request
		var wrapped_variant = wrap_variant(player_id,input);
		
		// Generate the message body
		size_t length;
		string json = Json.gvariant_serialize_data(wrapped_variant,out length);
		message.request_body.append(Soup.MemoryUse.TEMPORARY, json.data);

		stdout.printf("%s\n",input.print(true));		
				
		// Send the request json to the server		
      	session.send_message(message);

		//message.request_headers.foreach ((name, val) => {
		//	stdout.printf ("%s: %s\n", name, val);
		//});		
		//stdout.printf((string)message.request_body.flatten().data + "\n\n");
		
		//message.response_headers.foreach ((name, val) => {
		//	stdout.printf ("%s: %s\n", name, val);
		//});
    	//stdout.printf((string)message.response_body.flatten().data + "\n\n");
		
		var parser = new Json.Parser ();
		GLib.Variant output;
		// TODO: catch error here and rethrow something
		if ( message.response_body.flatten().data.length == 0 ) {
			throw new RPCError.EMPTY_RESPONSE( "Got empty response wqhen making JsonRPC call to " + uri + " with " + input.print(true) );
		}
		try {
			parser.load_from_data ((string) message.response_body.flatten().data, -1);
			output = Json.gvariant_deserialize( parser.get_root(), "a{sv}");
		} catch (Error e) {
			stderr.printf("Failed to make JsonRPC call to %s with %s", uri, input.print(true));
			throw new RPCError.FAILED_TO_PARSE_RESPONSE(e.message);
		}
		

		GLib.Variant result = output.lookup_value("result",new VariantType("a{sv}"));
		
		stdout.printf("%s\n",result.print(true));
				
		return result;
	}
	
	private GLib.Variant wrap_variant(string player_id,GLib.Variant input) {
		
		// Add Squeezebox JsonRPC wrapper to command
		var id_key = new Variant.string("id");
		var id_value = new Variant.variant(new Variant.int32(1));
		var id_entry = new Variant.dict_entry(id_key,id_value);
		var method_key = new Variant.string("method");
		var method_value = new Variant.variant(new Variant.string("slim.request"));
		var method_entry = new Variant.dict_entry( method_key, method_value);
		var player_variant = new Variant.string(player_id);
		Variant[] pa = {new Variant.variant(player_variant),new Variant.variant(input)};
		var player_array = new Variant.array(new VariantType("v"), pa);
		var params_key = new Variant.string("params");
		var params_value = new Variant.variant(player_array);
		var params_entry = new Variant.dict_entry( params_key, params_value);
		Variant[] a = {id_entry,method_entry,params_entry};
		var wrapped_variant = new Variant.array(new VariantType("{sv}"),a);
		
		return wrapped_variant;		
	}
}
