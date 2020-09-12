'''<Summary>The DOMMatrixReadOnly interface represents a read-only 4x4 matrix, suitable for 2D and 3D operations. The DOMMatrix interrface—which is based upon DOMMatrixReadOnly—adds mutability, allowing you to alter the matrix after creating it.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMMatrixReadOnly]
  '''<Summary>Returns a new DOMMatrix created by computing the dot product of the source matrix and the specified matrix: A⋅B. If no matrix is specified as the multiplier, the matrix is multiplied by a matrix in which every element is 0 except the bottom-right corner and the element immediately above and to its left: m33 and m34. These have the default value of 1. The original matrix is not modified.</Summary>
  Function [multiply]() As HTMLElement
  '''<Summary>Returns a new DOMMatrix created by rotating the source matrix by the given angle around the specified vector. The original matrix is not modified.</Summary>
  Function [rotateAxisAngle]() As Double
  '''<Summary>Returns a new DOMMatrix created by rotating the source matrix by the angle between the specified vector and (1, 0). The original matrix is not modified.</Summary>
  Function [rotateFromVector]() As Double
  '''<Summary>Returns a new Float32Array containing all 16 elements (m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44) which comprise the matrix. The elements are stored into the array as single-precision floating-point numbers in column-major (colexographical access or "colex") order; in other words, down the first column from top to bottom, then the second column, and so forth.</Summary>
  Function [toFloat32Array]() As HTMLElement
  '''<Summary>Returns a new Float64Array containing all 16 elements (m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44) which comprise the matrix. The elements are stored into the array as double-precision floating-point numbers in column-major (colexographical access access or "colex") order; in other words, down the first column from top to bottom, then the second column, and so forth.</Summary>
  Function [toFloat64Array]() As HTMLElement
  '''<Summary>Returns a JSON representation of the DOMMatrixReadOnly object.</Summary>
  Function [toJSON]() As DOMMatrixReadOnly
  '''<Summary> Creates and returns a DOMString object which contains a string representation of the matrix in CSS matrix syntax, using the appropriate CSS matrix notation. For a 2D matrix, the elements a through f are listed, for a total of six values and the form matrix(a, b, c, d, e, f). See the matrix() CSS function for details on this syntax. For a 3D matrix, the returned string contains all 16 elements and takes the form matrix3d(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44). See the CSS matrix3d() function for details on the 3D notation's syntax. Throws an InvalidStateError exception if any of the elements in the matrix are non-finite (even if, in the case of a 2D matrix, the non-finite values are in elements not used by the 2D matrix representation). </Summary>
  Function [toString]() As String
  '''<Summary>Transforms the specified point using the matrix, returning a new DOMPoint object containing the transformed point. Neither the matrix nor the original point are altered.</Summary>
  Function [transformPoint]() As DOMPoint
End Interface