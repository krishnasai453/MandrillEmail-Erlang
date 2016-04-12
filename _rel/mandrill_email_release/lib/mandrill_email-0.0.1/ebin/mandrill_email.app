{application, mandrill_email, [
	{description, "Send emails using mandrill email service"},
	{vsn, "0.0.1"},
	{modules, ['mandrill_email_app','mandrill_email_sup']},
	{registered, [mandrill_email_sup]},
	{applications, [kernel,stdlib,cowboy,jsx]},
	{mod, {mandrill_email_app, []}}
]}.