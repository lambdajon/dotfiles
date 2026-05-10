# factory: { timezone, locale }
{
  timezone ? "Asia/Tashkent",
  locale ? "en_US.UTF-8",
}:
{ ... }:
{
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  console.keyMap = "us";
}
