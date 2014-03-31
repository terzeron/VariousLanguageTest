/*
	Copyright 2002 Kevin O'Donnell

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/*
 * Include the core server components.
 */
#include "httpd.h"
#include "http_config.h"

/*
 * The default value for the error string.
 */
#ifndef DEFAULT_MODTUT2_STRING
#define DEFAULT_MODTUT2_STRING "apache2_mod_tut2: A request was made."
#endif

/*
 * This module
 */
module AP_MODULE_DECLARE_DATA tut2_module;

/*
 * This modules per-server configuration structure.
 */
typedef struct {
	char *string;
} modtut2_config;


/*
 * This function is registered as a handler for HTTP methods and will
 * therefore be invoked for all GET requests (and others).  Regardless
 * of the request type, this function simply sends a message to
 * STDERR (which httpd redirects to logs/error_log).  A real module
 * would do *alot* more at this point.
 */
static int mod_tut2_method_handler (request_rec *r)
{
	// Get the module configuration
	modtut2_config *s_cfg = ap_get_module_config(r->server->module_config, &tut2_module);

	// Send a message to the log file.
	fprintf(stderr,s_cfg->string);
	fprintf(stderr,"\n");

	// We need to flush the stream so that the message appears right away.
	// Performing an fflush() in a production system is not good for
	// performance - don't do this for real.
	fflush(stderr);

	// Return DECLINED so that the Apache core will keep looking for
	// other modules to handle this request.  This effectively makes
	// this module completely transparent.
	return DECLINED;
}

/*
 * This function is a callback and it declares what other functions
 * should be called for request processing and configuration requests.
 * This callback function declares the Handlers for other events.
 */
static void mod_tut2_register_hooks (apr_pool_t *p)
{
	// I think this is the call to make to register a handler for method calls (GET PUT et. al.).
	// We will ask to be last so that the comment has a higher tendency to
	// go at the end.
	ap_hook_handler(mod_tut2_method_handler, NULL, NULL, APR_HOOK_LAST);
}

/**
 * This function is called when the "ModTut2String" configuration directive is parsed.
 */
static const char *set_modtut2_string(cmd_parms *parms, void *mconfig, const char *arg)
{
	// get the module configuration (this is the structure created by create_modtut2_config())
	modtut2_config *s_cfg = ap_get_module_config(parms->server->module_config, &tut2_module);

	// make a duplicate of the argument's value using the command parameters pool.
	s_cfg->string = (char *) arg;

	// success
	return NULL;
}

/**
 * A declaration of the configuration directives that are supported by this module.
 */
static const command_rec mod_tut2_cmds[] =
{
	AP_INIT_TAKE1(
		"ModuleTutorialString",
		set_modtut2_string,
		NULL,
		RSRC_CONF,
		"ModTut2String <string> -- the string to print to the error log for each HTTP request."
	),
	{NULL}
};

/**
 * Creates the per-server configuration records.
 */
static void *create_modtut2_config(apr_pool_t *p, server_rec *s)
{
	modtut2_config *newcfg;

	// allocate space for the configuration structure from the provided pool p.
	newcfg = (modtut2_config *) apr_pcalloc(p, sizeof(modtut2_config));

	// set the default value for the error string.
	newcfg->string = DEFAULT_MODTUT2_STRING;

	// return the new server configuration structure.
	return (void *) newcfg;
}

/*
 * Declare and populate the module's data structure.  The
 * name of this structure ('tut2_module') is important - it
 * must match the name of the module.  This structure is the
 * only "glue" between the httpd core and the module.
 */
module AP_MODULE_DECLARE_DATA tut2_module =
{
	STANDARD20_MODULE_STUFF, // standard stuff; no need to mess with this.
	NULL, // create per-directory configuration structures - we do not.
	NULL, // merge per-directory - no need to merge if we are not creating anything.
	create_modtut2_config, // create per-server configuration structures.
	NULL, // merge per-server - hrm - examples I have been reading don't bother with this for trivial cases.
	mod_tut2_cmds, // configuration directive handlers
	mod_tut2_register_hooks, // request handlers
};
