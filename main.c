#include "cmacs.h"
#include <systemd/sd-bus.h>

static sd_bus_error error = SD_BUS_ERROR_NULL;
static sd_bus_message *message = null;
static sd_bus *bus = null;

static void
cleanup ()
{
  sd_bus_error_free (&error);
  sd_bus_message_unref (message);
  sd_bus_unref (bus);
}

static int
log_error (char *message, int error)
{
  cerr (message, strerror (-error));
  return error;
}

int
main (int argc, char *argv[])
{
  atexit (cleanup);
  int err = 0;
  err = sd_bus_open_user (&bus);
  if (err < 0)
    exit (log_error ("Failed to connect to user bus:", err));
  err = sd_bus_call_method (bus, "org.gnome.Shell",
                            "/org/gnome/Shell/Extensions/IbusSwitcher",
                            "org.gnome.Shell.Extensions.IbusSwitcher",
                            "CurrentSource", &error, &message, null);
  if (err < 0)
    exit (log_error ("Failed to issue method call:", err));
  char *str;
  err = sd_bus_message_read (message, "s", &str);
  u32 cur = atol (str);
  u32 nxt = !cur;
  err = sd_bus_call_method_async (bus, null, "org.gnome.Shell",
                                  "/org/gnome/Shell/Extensions/IbusSwitcher",
                                  "org.gnome.Shell.Extensions.IbusSwitcher",
                                  "SwitchSource", null, &error, "us", nxt, "");
  if (err < 0)
    exit (log_error ("Failed to issue method call:", err));
}
