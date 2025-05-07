use crate::config_parser;
use sonarr_api_rs;

pub fn test_connection(config: config_parser::Config) {
    sonarr_test(config.sonarr);
}

fn sonarr_test(sonarr: config_parser::Sonarr) {
    // Test connection to Sonarr
    let sonarr_url = sonarr.url;
    let sonarr_scheme = sonarr_url
        .scheme()
        .expect("ERROR: SONARR: Unable to get scheme from URL");
    let sonarr_ip = sonarr_url
        .host()
        .expect("ERROR: SONARR: Unable to get host from URL");
    let sonarr_port = sonarr_url.port().unwrap_or(8989);
    // let sonarr_url = format!("{}:{}", sonarr.host, sonarr.port);
    let sonarr_api_key = sonarr.api_key;

    // let sonarr_api_url = format!(
    //     "{}/api/v3/system/status?apikey={}",
    //     sonarr_url, sonarr_api_key
    // );

    let sonarr_base_path = format!("{}://{}:{}", sonarr_scheme, sonarr_ip, sonarr_port);

    let configuration = sonarr_api_rs::configuration::Configuration
        .new()
        .set_base_path(sonarr_base_path)
        .set_api_key(sonarr_api_key);

    // Test connection to Sonarr API
    let response = sonarr_api_rs::apis::api_info_api::api_get(configuration);
    if response.is_ok() {
        println!(
            "SUCCESS: Connected to Sonarr at {}:{}",
            sonarr_ip, sonarr_port
        );
    } else {
        eprintln!(
            "ERROR: Unable to connect to Sonarr at {}:{}",
            sonarr_ip, sonarr_port
        );
    }
}
