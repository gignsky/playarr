// ARGS Parser
use clap::Parser;
// // TUI Stuff
// use color_eyre::Result;
// use crossterm::event::{self, Event};
// use ratatui::{DefaultTerminal, Frame};

#[derive(Parser, Debug)]
#[clap(author = "Maxwell Rupp", version, about)]
/// Application configuration
struct Args {
    /// whether to be verbose
    #[arg(short = 'v')]
    verbose: bool,

    /// an optional name to greet
    #[arg()]
    name: Option<String>,
}

// Non-TUI Stuff
fn main() {
    let args = Args::parse();
    if args.verbose {
        println!("DEBUG {args:?}");
    }
    println!(
        "Hello {} (from playarr)!",
        args.name.unwrap_or("world".to_string())
    );
}

// // TUI Stuff
// fn main() -> Result<()> {
//     color_eyre::install()?;
//     let terminal = ratatui::init();
//     let result = run(terminal);
//     ratatui::restore();
//     result
// }

// fn run(mut terminal: DefaultTerminal) -> Result<()> {
//     loop {
//         terminal.draw(render)?;
//         if matches!(event::read()?, Event::Key(_)) {
//             break Ok(());
//         }
//     }
// }

// fn render(frame: &mut Frame) {
//     let args = Args::parse();
//     if args.verbose {
//         println!("DEBUG {args:?}");
//     }
//     let welcome_message = format!(
//         "Hello {} (from playarr)!",
//         args.name.unwrap_or("world".to_string())
//     );
//     frame.render_widget(welcome_message, frame.area());
// }
