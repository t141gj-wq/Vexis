/*
 * Standard definitions for Vexis OS
 */

#ifndef _STDDEF_H
#define _STDDEF_H

/* Null pointer constant */
#ifndef NULL
#define NULL ((void *)0)
#endif

/* Size type */
typedef unsigned int size_t;

/* Signed size type */
typedef int ssize_t;

/* Offset type */
typedef int ptrdiff_t;

/* Wide character type */
typedef int wchar_t;

/* Macro to get offset of a member in a structure */
#define offsetof(type, member) ((size_t) &((type *)0)->member)

#endif /* _STDDEF_H */
