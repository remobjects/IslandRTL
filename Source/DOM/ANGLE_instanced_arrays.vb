'''<summary>The ANGLE_instanced_arrays extension is part of the WebGL API and allows to draw the same object, or groups of similar objects multiple times, if they share the same vertex data, primitive count and type.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ANGLE_instanced_arrays]
  '''<summary> Behaves identically to gl.drawArrays() except that multiple instances of the range of elements are executed, and the instance advances for each iteration. </summary>
  Sub [drawArraysInstancedANGLE]([parmode] As Dynamic, [parfirst] As Dynamic, [parcount] As Dynamic, [parprimcount] As Dynamic)
  '''<summary> Behaves identically to gl.drawElements() except that multiple instances of the set of elements are executed and the instance advances between each set. </summary>
  Sub [drawElementsInstancedANGLE]([parmode] As Dynamic, [parcount] As Dynamic, [partype] As Dynamic, [paroffset] As Dynamic, [parprimcount] As Dynamic)
  '''<summary> Modifies the rate at which generic vertex attributes advance when rendering multiple instances of primitives with ext.drawArraysInstancedANGLE() and ext.drawElementsInstancedANGLE(). </summary>
  Sub [vertexAttribDivisorANGLE]([parindex] As Dynamic, [pardivisor] As Dynamic)
End Interface