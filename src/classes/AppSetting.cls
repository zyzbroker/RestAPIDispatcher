global without sharing class AppSetting {
    public static final String CURRENTNAMESPACE = AppSetting.class.getName().substringBefore('AppSetting').removeEnd('.');
    public static final String CURRENTNAMESPACEPREFIX = (String.isEmpty(CURRENTNAMESPACE)) ? '' : CURRENTNAMESPACE + '__';
}
