import { Button } from "@/components/ui/button";

const Header = () => {
  const navItems = [
    { label: "Features", href: "#features" },
    { label: "About", href: "#about" },
    { label: "Contact", href: "#contact" },
  ];

  return (
    <header className="border-b border-border">
      <div className="container mx-auto px-4 py-4 flex items-center justify-between">
        {/* Logo */}
        <div className="font-bold text-xl">
          Lovable
        </div>

        {/* Navigation */}
        <nav className="flex items-center space-x-6">
          {navItems.map((item) => (
            <a
              key={item.label}
              href={item.href}
              className="text-muted-foreground hover:text-foreground"
            >
              {item.label}
            </a>
          ))}
        </nav>

        {/* CTA Button */}
        <div className="flex items-center space-x-4">
          <Button variant="ghost">
            Sign In
          </Button>
          <Button>
            Get Started
          </Button>
        </div>
      </div>
    </header>
  );
};

export default Header;