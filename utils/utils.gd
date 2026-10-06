extends RefCounted

static func enum_to_str(enum_val, enum_type):
	return str(enum_type.find_key(enum_val))
