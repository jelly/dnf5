Feature: dnf-automatic dumps its resolved configuration


Scenario: dnf-automatic dumps configuration after applying overrides
  Given I create file "/usr/share/dnf5/dnf5-plugins/automatic.conf" with
    """
    [commands]
    upgrade_type = security
    random_sleep = 120
    download_updates = no

    [emitters]
    emit_via = stdio, email
    system_name = distribution-default

    [email]
    email_host = distribution.example
    """
  Given I create file "/etc/dnf/automatic.conf.d/10-local.conf" with
    """
    [commands]
    random_sleep = 5

    [emitters]
    system_name = local-machine

    [email]
    email_host = local.example
    """
   When I execute dnf with args "automatic --dump-config --installupdates"
   Then the exit code is 0
    And stdout contains lines
    """
    [commands]
    apply_updates = yes
    download_updates = no
    random_sleep = 5
    upgrade_type = security
    [emitters]
    emit_via = stdio,email
    system_name = local-machine
    [email]
    email_host = local.example
    [command]
    [command_email]
    """
    And stdout does not contain "Resolved transaction:"
