// Copyright (c) 2002 Sean Kelly
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the
//    distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// $Id$

package net.sourceforge.xmlresume;

import java.util.HashSet;
import java.util.Set;

/**
 * An XSL parameter setting.
 *
 * Objects of this class describe an XSL parameter, including its name and all possible
 * values it may take.
 *
 * @author Kelly
 */
class Parameter {
	/**
	 * Creates a new <code>Parameter</code> instance.
	 *
	 * @param name Name of the parameter.
	 * @param values A {@link Set} of {@link String} values it may take.
	 */
	public Parameter(String name, Set values) {
		this.name = name;
		this.values = values;
	}

	/**
	 * Creates a new <code>Parameter</code> instance.
	 *
	 * @param name Name of the parameter.
	 */
	public Parameter(String name) {
		this.name = name;
		values = new HashSet();
	}

	/**
	 * Get the name of this parameter.
	 *
	 * @return Its name.
	 */
	public String getName() {
		return name;
	}

	/**
	 * Add a possible value to this parameter.
	 *
	 * @param value a <code>String</code> value.
	 */
	public void addValue(String value) {
		values.add(value);
	}

	/**
	 * Get the set of all possible values of this parameter.
	 *
	 * @return A {@link Set} of {@link String} values it may take.
	 */
	public Set getValues() {
		return values;
	}

	public String toString() {
		return "Parameter[name=" + name + ",values=" + values + "]";
	}

	public int hashCode() {
		return (name.hashCode() << 16) & values.hashCode();
	}

	public boolean equals(Object obj) {
		if (obj == this) return true;
		if (!(obj instanceof Parameter)) return false;
		Parameter rhs = (Parameter) obj;
		return name.equals(rhs.name) && values.equals(rhs.values);
	}

	/** Name of parameter. */
	private String name;

	/** Set of possible values, which are all {@link String}s. */
	private Set values;
}
