/* squeezeboxapi.vala
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
 
public class Squeezebox.API {

	private Squeezebox.RPC squeezeboxrpc;
	 
	public API(string host, string port) {
		this.squeezeboxrpc = new Squeezebox.RPC(host, port);
	}
	
	public int player_count() throws RPCError {
		
		Variant[] params = {
			new Variant.string("player"),
			new Variant.string("count"),
			new Variant.string("?")
		};
		
		GLib.Variant result = squeezeboxrpc.call_rpc("",build_variant_array(params));
		return (int)result.lookup_value("_count",new VariantType("x")).get_int64();
	}
	
	public string player_id(int player_index) throws RPCError {
		
		Variant[] params = {
			new Variant.string("player"),
			new Variant.string("id"),
			new Variant.int64(player_index),
			new Variant.string("?")
		};
		
		GLib.Variant result = squeezeboxrpc.call_rpc("",build_variant_array(params));
		return result.lookup_value("_id",new VariantType("s")).get_string();
	}

	public string player_name(string player_id) throws RPCError {
		
		Variant[] params = {
			new Variant.string("player"),
			new Variant.string("name"),
			new Variant.string(player_id),
			new Variant.string("?")
		};
		
		GLib.Variant result = squeezeboxrpc.call_rpc("",build_variant_array(params));
		return result.lookup_value("_name",new VariantType("s")).get_string();
	}
	
	public bool player_power(string player_id) throws RPCError {
		
		Variant[] params = {
			new Variant.string("power"),
			new Variant.string("?")
		};
		
		GLib.Variant result = squeezeboxrpc.call_rpc(player_id,build_variant_array(params));
		return result.lookup_value("_power",new VariantType("s")).get_string() == "1";
	}
		
	public GLib.Variant server_status() throws RPCError{
		
		Variant[] params = {
			new Variant.string("serverstatus"),
			new Variant.int32(0),
			new Variant.int32(999)
		};
		
		GLib.Variant result = squeezeboxrpc.call_rpc("dfdfdf",build_variant_array(params));		
		return result;			
	}
	
	// Convert an raw array of variants into a Variant of type array
	private Variant build_variant_array(Variant[] params) {		
		Variant[] variant_array = {};
		foreach (Variant v in params) {
			variant_array += new Variant.variant(v);
		}
		
		return new Variant.array(new VariantType("v"),variant_array);
	}

}
