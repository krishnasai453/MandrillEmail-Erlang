{application, mandrill_email, [
	{description, "Mandrill email Application"},
	{vsn, "0.1.0"},
	{id, ""},
	{modules, ['email_handler','mandrill_email_app','mandrill_email_sup','mandrillemail']},
	{registered, []},
	{applications, [
		kernel,
		stdlib,
		cowboy,
		asn1,public_key,
		ssl,inets


	]},
	{mod, {mandrill_email_app, []}},
	{env, []}
]}.
