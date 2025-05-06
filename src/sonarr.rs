use serde::Deserialize;

#[derive(Deserialize)]
pub struct Sonarr {
    pub url: String,
    pub api_key: String,
}
